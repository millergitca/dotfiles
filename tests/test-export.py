#!/usr/bin/env python3
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
spec=importlib.util.spec_from_file_location('exporter',Path(__file__).resolve().parents[1]/'scripts/export-curated-config.py')
m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
class ExportTests(unittest.TestCase):
 def setUp(self):
  self.temp=tempfile.TemporaryDirectory();self.root=Path(self.temp.name).resolve();self.source=self.root/'curated';self.source.mkdir();(self.source/m.MARKER).write_text(json.dumps({'kind':'curated-export','version':1}));(self.source/'ghostty').mkdir();(self.source/'ghostty/config').write_text('font-size = 12\n')
 def tearDown(self):self.temp.cleanup()
 def test_dry_and_write(self):
  self.assertEqual(m.export(self.source,['ghostty/config'])['files'][0]['path'],'ghostty/config');out=self.root/'export';self.assertFalse(out.exists());m.export(self.source,['ghostty/config'],out);self.assertEqual((out/'ghostty/config').read_text(),'font-size = 12\n');self.assertRaises(ValueError,m.export,self.source,['ghostty/config'],out)
 def test_paths(self):
  for name in ['../secret','.ssh/id','Downloads/file','ghostty/*','ghostty/config/other']:self.assertRaises(ValueError,m.export,self.source,[name])
  p=self.source/'ghostty/config';p.unlink();p.symlink_to(self.root/'missing');self.assertRaises(ValueError,m.export,self.source,['ghostty/config'])
 def test_content(self):
  for value in ['password = fixture','/home/'+'fictional/private','192.168.1.2','demo@example.invalid','hostname=fixture']:
   (self.source/'ghostty/config').write_text(value);out=self.root/'out';self.assertRaises(ValueError,m.export,self.source,['ghostty/config'],out);self.assertFalse(out.exists())
 def test_git_destination(self):
  (self.root/'.git').mkdir();self.assertRaises(ValueError,m.export,self.source,['ghostty/config'],self.root/'export')
 def test_marker_and_duplicates(self):
  self.assertRaises(ValueError,m.export,self.source,['ghostty/config','ghostty/config']);(self.source/m.MARKER).unlink();self.assertRaises(ValueError,m.export,self.source,['ghostty/config'])
unittest.main()
