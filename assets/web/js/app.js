const editor = document.getElementById('editor');

const FlutterBridge = {
  send: function (message) {
    if (window.FlutterBridge) {
      window.FlutterBridge.postMessage(message);
    } else {
      try {
        FlutterBridge.postMessage(message);
      } catch (e) {
        console.log('FlutterBridge:', message);
      }
    }
  }
};

window.editor = {
  setContent: function (title, content) {
    if (content) {
      editor.innerHTML = content;
    } else {
      editor.innerHTML = '';
    }
    FlutterBridge.send('ready');
  },

  getContent: function () {
    return editor.innerHTML;
  },

  clear: function () {
    editor.innerHTML = '';
  }
};

function execCmd(command, value) {
  document.execCommand(command, false, value || null);
  editor.focus();
  notifyFlutter();
}

function notifyFlutter() {
  const content = editor.innerHTML;
  FlutterBridge.send('content:' + content);

  const titleEl = editor.querySelector('h1');
  const title = titleEl ? titleEl.textContent.trim() : '';
  FlutterBridge.send('title:' + title);
}

editor.addEventListener('input', function () {
  notifyFlutter();
});

editor.addEventListener('keydown', function (e) {
  if (e.key === 'Tab') {
    e.preventDefault();
    document.execCommand('insertHTML', false, '&nbsp;&nbsp;&nbsp;&nbsp;');
  }
});

FlutterBridge.send('ready');
