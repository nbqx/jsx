#target indesign-7.0
#include 'lodash.custom.js'

var tpl = _.template('Hello, <%= name %>');
var data = tpl({name: 'テスト'});
alert(data);