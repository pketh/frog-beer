// Generated by CoffeeScript 1.9.0
(function() {
  var activePalette, highlightActivePaletteColor, newPalette, pressingDown, selectColor, updatePalette;

  activePalette = [];

  pressingDown = false;

  selectColor = function(context) {
    var color;
    color = $(context).css('background-color');
    return highlightActivePaletteColor(context);
  };

  highlightActivePaletteColor = function(context) {
    $('.color').removeClass('active');
    return $(context).addClass('active');
  };

  updatePalette = function() {
    var color, context, index, paletteContext, _i, _len, _results;
    _results = [];
    for (index = _i = 0, _len = activePalette.length; _i < _len; index = ++_i) {
      color = activePalette[index];
      paletteContext = $('.palette-color')[index];
      $(paletteContext).css('background-color', color);
      if (index === 0) {
        context = $('.palette-color')[0];
        _results.push(selectColor(context));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  newPalette = function() {
    var palette, shuffledPalettes, _i, _len, _results;
    shuffledPalettes = _.shuffle(palettes);
    _results = [];
    for (_i = 0, _len = shuffledPalettes.length; _i < _len; _i++) {
      palette = shuffledPalettes[_i];
      if (_.isEqual(activePalette, palette) === false) {
        activePalette = palette;
        updatePalette();
        break;
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  $('.color').not('.shuffle').click(function() {
    var context;
    context = this;
    return selectColor(context);
  });

  $(document).keypress(function(key) {
    var context;
    if (key.which === 49) {
      context = $('.color')[0];
      return selectColor(context);
    } else if (key.which === 50) {
      context = $('.color')[1];
      return selectColor(context);
    } else if (key.which === 51) {
      context = $('.color')[2];
      return selectColor(context);
    } else if (key.which === 52) {
      context = $('.color')[3];
      return selectColor(context);
    } else if (key.which === 53) {
      context = $('.color')[4];
      return selectColor(context);
    } else if (key.which === 54) {
      context = $('.color')[5];
      return selectColor(context);
    }
  });

  if (typeof palettes !== "undefined" && palettes !== null) {
    newPalette();
  }

  $('.shuffle').click(function() {
    return newPalette();
  });

  $('.pixel').mousedown(function() {
    var color;
    color = $('.color.active').css('background-color');
    pressingDown = true;
    return $(this).css("background-color", color);
  });

  $(document).mouseup(function() {
    return pressingDown = false;
  });

  $('.pixel').mousemove(function() {
    var color;
    color = $('.color.active').css('background-color');
    if (pressingDown) {
      return $(this).css("background-color", color);
    }
  });

}).call(this);
