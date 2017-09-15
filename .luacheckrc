stds.sOS = {
  globals = { 
    'state', 'apps', 'grid',
    'gra', 'app', 'lgc', 'api', 'utf8',
  };
  read_globals = {};
}


return {
  codes = true;
  std = 'luajit+love+sOS';
  ignore = {
    '611'
  };
}