function ready(fn) {
  if (document.addEventListener) {
    document.addEventListener('DOMContentLoaded', fn);
  } else {
    document.attachEvent('onreadystatechange', function() {
      if (document.readyState === 'interactive')
        fn();
    });
  }
}

ready(function addOneTimeMessagesCallbacks() {
	var closeButton = document.getElementById('starburst-close');
	if (closeButton !== null) {
		closeButton.addEventListener('click', function() {
			document.getElementById('starburst-announcement').style.display = 'none';
		});
	}
});