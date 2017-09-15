stds.sOS = {
  globals = { 
    'state', 'apps', 'grid',
    'gra', 'app', 'lgc', 'api', 'utf8',
  };
  read_globals = {};
}


local trav = os.genenv('$TRAVIS_BUILD_DIR')


return {
  codes = true;
  std = 'luajit+love+sOS';
  ignore = {
    '611',
    '111',
    '112',
    '113'
  };
  formatter = 'TAP';
  include_files = {
    trav..'/os',
    trav..'/packages',
    trav..'/programs',
    trav..'/main.lua'
  };
  exclude_files = {
    trav..'/programs/test.lua'
  }
}