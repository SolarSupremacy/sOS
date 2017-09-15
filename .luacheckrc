stds.sOS = {
  globals = { 
    'state', 'apps', 'grid',
    'gra', 'app', 'lgc', 'api', 'utf8',
  };
  read_globals = {};
}


local trav = os.getenv('TRAVIS_BUILD_DIR')


return {
  codes = true;
  std = 'luajit+love+sOS';
  ignore = {
    '611',
  };
  exclude_files = {
    trav..'./programs/test.lua'
  };
  files = {
    ['main.lua'] = {
      ignore = {
        '212'
      }
    }
  }
}