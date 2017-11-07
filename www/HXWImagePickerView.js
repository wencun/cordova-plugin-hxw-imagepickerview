var exec = require('cordova/exec');

exports.openImagePickerView = function(arg0, success, error) {
    exec(success, error, "HXWImagePickerView", "openImagePickerView", [arg0]);
};
