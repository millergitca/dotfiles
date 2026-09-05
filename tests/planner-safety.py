#!/usr/bin/env python3
"""Fixture repository only; never applies or inspects personal configuration."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import unittest
ROOT=Path(__file__).resolve().parents[1]
@unittest.skipIf(os.geteuid()==0,'Planner rejects root; non-root CI covers plans')
class Planner(unittest.TestCase):
 def test_plans_and_guards(self):
  for profile in ['minimal','developer','complete']:
   result=subprocess.run(['bash',str(ROOT/'scripts/install.sh'),'--profile',profile,'--plan-anywhere','--no-dotfiles'],capture_output=True,text=True)
   self.assertEqual(result.returncode,0);self.assertIn('PLAN ONLY',result.stdout)
  result=subprocess.run(['bash',str(ROOT/'scripts/install.sh'),'--profile','minimal','--plan-anywhere','--apply'],capture_output=True,text=True)
  self.assertNotEqual(result.returncode,0);self.assertIn('cannot be combined',result.stderr)
 def test_package_fixture(self):
  with tempfile.TemporaryDirectory() as directory:
   root=Path(directory);shutil.copytree(ROOT/'scripts',root/'scripts');shutil.copytree(ROOT/'packages',root/'packages');shutil.copy2(ROOT/'VERSION',root/'VERSION')
   package=root/'packages/core.txt';package.write_text('synthetic-last-package')
   command=['bash',str(root/'scripts/install.sh'),'--profile','minimal','--plan-anywhere','--no-dotfiles']
   result=subprocess.run(command,capture_output=True,text=True);self.assertEqual(result.returncode,0);self.assertIn('synthetic-last-package',result.stdout)
   package.write_text('--malicious-option\n');result=subprocess.run(command,capture_output=True,text=True);self.assertNotEqual(result.returncode,0);self.assertIn('Invalid package name',result.stderr)
unittest.main()
