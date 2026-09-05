#!/usr/bin/env python3
"""Scan a manually curated directory; never discover or read a user's home."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil

ALLOW = frozenset({'hypr/hyprland.conf', 'waybar/config.jsonc', 'waybar/style.css',
                   'ghostty/config', 'nvim/init.lua', 'zsh/config.zsh', 'packages/selected.txt'})
MARKER = '.mncm-curated-export.json'
PATTERNS = (
    r'-----BEGIN [A-Z ]*PRIVATE KEY-----',
    r'(?i)(?:password|secret|access_token|refresh_token|api_key)\s*[:=]\s*[\"\']?[^\s\"\']+',
    r'(?i)(?:/Users/|/home/|[A-Z]:\\Users\\|\.ssh/|\.gnupg/|Documents/|Downloads/|Photos/)',
    r'(?i)(?:sk_(?:live|test)_|gh[pousr]_)[A-Za-z0-9_]{12,}',
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
    r'\b(?:10|127)\.\d+\.\d+\.\d+\b|\b192\.168\.\d+\.\d+\b',
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
    r'(?i)(?:hostname|machine-id|serial-number)\s*[:=]',
)

def scan(text):
    if any(re.search(pattern, text) for pattern in PATTERNS):
        raise ValueError('Sensitive or machine-specific content; review manually (content omitted)')

def plan(source, files):
    source = Path(source)
    if source.is_symlink() or source.resolve() == Path.home() or source.resolve() == Path('/'):
        raise ValueError('Use a manually curated directory, never home/root')
    source = source.resolve(strict=True)
    marker = source / MARKER
    if marker.is_symlink() or not marker.is_file() or marker.stat().st_size > 200:
        raise ValueError('Missing curated-source marker')
    if json.loads(marker.read_text()) != {'kind': 'curated-export', 'version': 1}:
        raise ValueError('Invalid curated-source marker')
    if not files or len(files) != len(set(files)) or not set(files) <= ALLOW:
        raise ValueError('Choose unique exact allowlisted files; no discovery/globs')
    result = []
    for relative in sorted(files):
        file = source / relative
        if any(p.is_symlink() for p in [file, *file.parents] if p != source.parent):
            raise ValueError('Symlink input refused')
        if not file.is_file() or file.stat().st_size > 262144:
            raise ValueError('Regular bounded text file required')
        data = file.read_bytes()
        scan(data.decode('utf-8'))
        result.append((relative, data))
    return result

def export(source, files, output=None):
    items = plan(source, files)  # Validate everything before writing anything.
    manifest = {'version': 1, 'files': [{'path': name, 'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)} for name, data in items]}
    if output is not None:
        output = Path(output).absolute()
        if output.exists() or output.is_symlink() or any((p/'.git').exists() for p in output.parents):
            raise ValueError('Output must be new staging outside Git')
        if output.parent.resolve() != output.parent:
            raise ValueError('Output parent must be canonical, without symlinks')
        output.mkdir(mode=0o700)
        try:
            for name, data in items:
                target = output/name
                target.parent.mkdir(parents=True, exist_ok=True)
                with target.open('xb') as stream:
                    stream.write(data)
                target.chmod(0o600)
            (output/'export-manifest.json').write_text(json.dumps(manifest, indent=2)+'\n')
        except Exception:
            shutil.rmtree(output)  # Only this invocation's new staging directory.
            raise
    return manifest

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', required=True)
    parser.add_argument('--file', action='append', required=True)
    parser.add_argument('--output', help='Explicitly write new staging; omitted means dry run')
    args = parser.parse_args()
    try:
        print(json.dumps(export(args.source, args.file, args.output), indent=2))
    except (ValueError, OSError, UnicodeError) as error:
        parser.exit(1, 'Export refused: '+str(error)+'\n')
