(function() {
  module.exports = function(message, sender, type) {
    var item, messageString, messageToDisplay, _i, _len;
    if (type === 'linklist') {
      console.log('received: ' + message.length);
      messageString = '';
      for (_i = 0, _len = message.length; _i < _len; _i++) {
        item = message[_i];
        messageString = messageString + '<li><a href=#' + item.title + '>' + item.title + '</a></li>';
      }
      messageToDisplay = '<div class="' + sender + " " + type + '">' + messageString + '</div>';
    } else if (type) {
      messageToDisplay = '<div class="' + sender + " " + type + '">' + message + '</div>';
    } else {
      messageToDisplay = '<div class=' + sender + '>' + message + '</div>';
    }
    return messageToDisplay;
  };

}).call(this);

 //# sourceMappingURL=generateMessage.js.map