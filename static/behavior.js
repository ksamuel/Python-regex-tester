$(function(){

   var $tooltip = $('#tooltip');
   var $replace = $('#replace');
   var typing_timer = null;

   $('#flags dt').bind('mouseover', function(e){
        var $this = $(this);
        $tooltip.children().remove()
        var offset = $this.offset();
        $('<p>' + $(this).next().text() + '</p>').appendTo($tooltip);
        $tooltip.css({position: 'absolute',
                      top:offset.top + 35,
                      left:offset.left,
                      display:'block' });
   });
   $('#flags dt').bind('mouseout', function(e){
        $tooltip.css({display:'none'});
   });
   $('#help').toggleClass('hide');
   $('#submit a').css({display:'inline'}).bind('click', function(){
        $('#help').toggleClass('hide');
        return false;
   });

   $('form').bind('submit', function(e){

      $.post('/', $('form').serializeArray(this), function(data) {
        if (!$("textarea").is(":focus")) {
          $('#result').replaceWith($(data).find('#result'));
          populate_text_div();
        }
      }, 'html');

      return false;
   });

   $('input[type=text]').live('keyup', function(){
      if(typing_timer) {
         window.clearTimeout(typing_timer);
      }
      typing_timer = window.setTimeout(function(){
        $('form').submit();
      }, 500);
   });

   $('input').live('change', function(){
      $('form').submit();
   });

   $('input[name=function]').live('change', function(){
       if ($("input[name=function]:checked").val().indexOf('sub') != 0) {
          $replace.addClass('hide');
       } else {
         $replace.removeClass('hide');
       }
   });

   $('input[name=function]').change();

   $('div.text').live('click', function(e){
      $('textarea.text').removeClass('hide');
      $('div.text').addClass('hide');
      $('textarea.text').focus()
   });

   var populate_text_div = function(){

      $('textarea.text').addClass('hide');
      $('div.text').removeClass('hide');
      $('div.text').text(string);

      var string = $('textarea.text').val();

      var markers = eval($('#markers').text());

      if (markers.length) {
        var chunk = '';
        var list = [];
        var index = markers.shift();
        var length = string.length;

        for (var i = 0; i < length; i++) {
            if (i === index) {
                list.push(chunk);
                chunk = '';
                index = markers.shift();
            }
            chunk += string[i];
        }

        list.push(chunk);


        var result = '';
        var length = list.length;
        for (var i = 0; i < length; i++) {
            if (i % 2 != 0) {
                result += '<strong>' + list[i] + '</strong>'
            } else {
                result += list[i];
            }
        }

      }

      $('div.text').html(result || string);
   }

   $('body').click(function(){
      if (!$('textarea.text').hasClass('hide')) {
        $('form').submit();
      }
   });

   $('textarea.text').click(function(event){
      event.stopPropagation();
   });


});