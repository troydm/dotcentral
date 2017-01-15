//
// _smooziee.js
//
// LICENSE: {{{
//   Copyright (c) 2009 snaka<snaka.gml@gmail.com>
//
//     distributable under the terms of an MIT-style license.
//     http://www.opensource.jp/licenses/mit-license.html
// }}}
//
// PLUGIN INFO: 
// var INFO =
// <plugin name="smooziee" version="2.3" 
//    href="https://github.com/vimpr/vimperator-plugins/raw/master/_smooziee.js"
//    summary="At j,k key scrolling to be smooth" 
//    xmlns="http://vimperator.org/namespaces/liberator">
//   <author email="snaka.gml@gmail.com" homepage="http://vimperator.g.hatena.ne.jp/snaka72/">snaka</author>
//   <license>MIT style license</license>
//   <p>
//     == Subject ==
//     j,k key scrolling to be smoothly.
// 
//     == Global variables ==
//     You can configure following variable as you like.
//     :smooziee_scroll_amount: Scrolling amount(unit:px). Default value is 400px.
//     :smooziee_interval: Scrolling interval(unit:ms). Default value is 20ms.
// 
//     === Excample ===
//     Set scroll amount is 300px and interval is 10ms.
//     let g:smooziee_scroll_amount="300"
//     let g:smooziee_scroll_interval="10"
// 
//     == API ==
//     smooziee.smoothScrollBy(amount);
//     Example.
//     :js liberator.plugins.smooziee.smoothScrollBy(600)
//     :js liberator.plugins.smooziee.smoothScrollBy(-600)
//   </p>
// </plugin>;

let self = liberator.plugins.smooziee = (function(){

  // Mappings  {{{
  mappings.addUserMap(
    [modes.NORMAL],
    ["j"],
    "Smooth scroll down",
    function(count){
      self.smoothScrollBy(getScrollAmount() * (count || 1));
    },
    {
      count: true
    }
  );
  mappings.addUserMap(
    [modes.NORMAL],
    ["k"],
    "Smooth scroll up",
    function(count){
      self.smoothScrollBy(getScrollAmount() * -(count || 1));
    },
    {
      count: true
    }
  );
  // }}}
  // PUBLIC {{{
  var PUBLICS = {
    smoothScrollBy: function(moment) {
      win = Buffer.findScrollableWindow();
      interval = window.eval(liberator.globalVariables.smooziee_scroll_interval || '20');
      destY = win.scrollY + moment;
      clearTimeout(next);
      smoothScroll(moment);
    }
  }

  // }}}
  // PRIVATE {{{
  var next;
  var destY;
  var win;
  var interval;

  function getScrollAmount() window.eval(liberator.globalVariables.smooziee_scroll_amount || '400');

  function smoothScroll(moment) {
    if (moment > 0)
      moment = Math.floor(moment / 2);
    else
      moment = Math.ceil(moment / 2);

    win.scrollBy(0, moment);

    if (Math.abs(moment) < 1) {
      setTimeout(makeScrollTo(win.scrollX, destY), interval);
      destY = null;
      return;
    }
    next = setTimeout(function() smoothScroll(moment), interval);
  }

  function makeScrollTo(x, y) function() win.scrollTo(x, y);
  // }}}
  return PUBLICS;
})();
// vim: sw=2 ts=2 et si fdm=marker:
