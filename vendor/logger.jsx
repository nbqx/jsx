//Logファイル作成用ユーティリティ

Logger = this.Logger = function () {

  //ログファイル名を保持する
  this.filename = "";
  //ログファイルの文字コード
  this.encoding = "UTF-8";
  //ログファイルの改行コード
  this.NL = "\r\n";
  //ログファイルにつけるprefix
  this.prefix = "";
  //ログファイルにつけるsuffix
  this.suffix = "のログ";
  //ログファイルのコンテンツ(Logger.writeしたときにjoinして出力する)
  this.contents = [];
};


//ログファイルにログを追加する
Logger.prototype.add = function(txt){
  var txt = txt;

  //Logger.filenameが設定されていなければ設定する
  if(this.filename===""){
    var now = new Date();
    var filename = [
      this.prefix,
      new Logger().getTimeString(),
      this.suffix
    ].join('');
    this.filename = filename;
  }

  //txtをLogger.contentsに追加する
  if(txt){
    this.contents.push(txt);
  }
};

//ログファイルを引数のディレクトリに書きだす
Logger.prototype.write = function(dir){
  var dir_name = dir;
  var folder = new Folder(dir_name);

  //書きだすフォルダの存在チェック
  //もし存在しないフォルダであればデスクトップに書きだす
  if(folder.exists===false){
    alert("Logger: 指定したフォルダが見つかりませんでしたのでデスクトップに保存します");
    dir_name = "~/Desktop";
    folder = new Folder(dir_name);
  }

  //Fileオブジェクトの生成と文字コードの設定
  var log_file = new File(dir_name+"/"+this.filename+".txt");
  log_file.encoding = this.encoding;

  //ファイルへの書きこみ
  if(log_file.open("w")){
    var cont = this.contents.join(this.NL);
    log_file.write(cont);
    log_file.close();
    alert("Logger: ログファイルを書きだしました");
  }else{
    alert("Logger: ファイルのエラーが発生しました");
  }

  //Loggerのオブジェクトをリセット
  this.filename = "";
  this.contents = [];
  
};

//ログファイルを引数のディレクトリに書きだす
Logger.prototype.writep = function(dir){
  var dir_name = dir;
  var folder = new Folder(dir_name);

  //書きだすフォルダの存在チェック
  //もし存在しないなら中止
  if(folder.exists===false){
    alert("Logger: 指定したフォルダが見つかりませんでしたので中止します");
    exit();
  }

  //Fileオブジェクトの生成と文字コードの設定
  var log_file = new File(dir_name+"/"+this.filename+".txt");
  log_file.encoding = this.encoding;

  //ファイルへの書きこみ
  var ret;
  if(log_file.open("w")){
    var cont = this.contents.join(this.NL);
    log_file.write(cont);
    log_file.close();
    ret = {mess: "Logger: ログファイルを書きだしました", path: log_file};
  }else{
    ret = {mess: "Logger: ファイルのエラーが発生しました", path: log_file};
  }

  //Loggerのオブジェクトをリセット
  this.filename = "";
  this.contents = [];
  return ret;
};

// ログファイルを引数のファイルへ上書き
Logger.prototype.override = function(file) {
  var log_file = file;
  log_file.encoding = this.encoding;
  //ファイルへの書きこみ
  var ret;
  if(log_file.open("e")){
    log_file.seek(0, 2);
    var cont = this.contents.join(this.NL);
    log_file.write(cont);
    log_file.close();
    ret = {mess: "Logger: ログファイルを書きだしました", path: file};
  }else{
    ret = {mess: "Logger: ファイルのエラーが発生しました", path: file};
  }

  //Loggerのオブジェクトをリセット
  this.filename = "";
  this.contents = [];
  return ret;
};
// タイムスタンプ
// 引数=1      => 2012年01月17日14時44分48秒
// 引数=2      => 2012-01-17_14-44-48
// 引数=3      => 20120117-144448
// それ以外デフォルト => 2012年01月17日14時44分48秒 (1と同じ)
Logger.prototype.getTimeString = function(format) {
  var now = new Date();
  var zero_padding = function (num, digit) {
    var nums = num+"";
    while (nums.length < digit){
      nums = "0"+nums;
    }
    return nums;
  }
  var timef;
  switch(format){
    case 1:
    // 2012年01月17日14時44分48秒
      timef = [
      now.getFullYear(),"年",
      zero_padding(now.getMonth()+1, 2),"月",
      zero_padding(now.getDate(), 2),"日",
      zero_padding(now.getHours(), 2),"時",
      zero_padding(now.getMinutes(), 2),"分",
      zero_padding(now.getSeconds(), 2),"秒"
      ].join('');
      break;
    case 2:
    // 2012-01-17_14-44-48
      timef = [
      now.getFullYear(), "-",
      zero_padding(now.getMonth()+1, 2), "-",
      zero_padding(now.getDate(), 2), "_",
      zero_padding(now.getHours(), 2), "-",
      zero_padding(now.getMinutes(), 2), "-",
      zero_padding(now.getSeconds(), 2)
      ].join('');
      break;
    case 3:
    // 20120117-144448
      timef = [
      now.getFullYear(),
      zero_padding(now.getMonth()+1, 2),
      zero_padding(now.getDate(), 2), "-",
      zero_padding(now.getHours(), 2),
      zero_padding(now.getMinutes(), 2),
      zero_padding(now.getSeconds(), 2)
      ].join('');
      break;
    default:
    // 2012年01月17日14時44分48秒
      timef = [
      now.getFullYear(),"年",
      zero_padding(now.getMonth()+1, 2),"月",
      zero_padding(now.getDate(), 2),"日",
      zero_padding(now.getHours(), 2),"時",
      zero_padding(now.getMinutes(), 2),"分",
      zero_padding(now.getSeconds(), 2),"秒"
      ].join('');
      break;
  }
  return timef;
};
