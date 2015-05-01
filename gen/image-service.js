// Generated by CoffeeScript 1.9.0
(function() {
  var ImageSearchService,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ImageSearchService = (function() {
    function ImageSearchService() {
      this.saveImage = __bind(this.saveImage, this);
      this.findImagesFor = __bind(this.findImagesFor, this);
      this.initialize = __bind(this.initialize, this);
    }

    ImageSearchService.prototype.appKey = "AIzaSyB83ol3E5p9fUSQPapia3TbwhAPVzLt2t8";

    ImageSearchService.prototype.engineKey = "015762953028935180710:bgwcqasc418";

    ImageSearchService.prototype.initialize = function(http, cordovaFileT) {
      this.http = http;
      this.cordovaFileT = cordovaFileT;
      return console.log("Cordova file transfer is: " + this.cordovaFileT);
    };

    ImageSearchService.prototype.findImagesFor = function(query, callback) {
      var engine, key, safety, size, type, url;
      key = "key=" + this.appKey;
      engine = "cx=" + this.engineKey;
      type = "searchType=image";
      safety = "safe=medium";
      size = "imgSize=medium";
      query = "q=" + query;
      url = "https://www.googleapis.com/customsearch/v1?" + key + "&" + engine + "&" + type + "&" + safety + "&" + size + "&" + query;
      return this.http.get(url).error(function(data, status, headers, config) {
        return callback(data);
      }).success(function(data, status, headers, config) {
        return callback(void 0, data.items);
      });
    };

    ImageSearchService.prototype.saveImage = function(url, filename, callback) {
      var options, targetPath, trustHosts;
      targetPath = cordova.file.externalDataDirectory + filename;
      console.log("SAVING IMAGE TO " + targetPath);
      trustHosts = true;
      options = {};
      return this.cordovaFileT.download(url, targetPath, options, trustHosts).then(function(result) {
        console.log("SAVED IMAGE TO " + targetPath);
        return callback(targetPath);
      }, function(error) {
        console.log("ERROR: " + JSON.stringify(error, null, 2));
        return callback();
      });
    };

    return ImageSearchService;

  })();

  module.exports = new ImageSearchService();

}).call(this);
