Array.prototype.equals = function (array) {
  // if the other array is a falsy value, return
  if (!array)
    return false;

  // compare lengths - can save a lot of time
  if (this.length != array.length)
    return false;

  for (var i = 0, l=this.length; i < l; i++) {
    // Check if we have nested arrays
    if (this[i] instanceof Array && array[i] instanceof Array) {
      // recurse into the nested arrays
      if (!this[i].equals(array[i]))
        return false;
    }
    else if (this[i] != array[i]) {
      // Warning - two different object instances will never be equal: {x:20} != {x:20}
      return false;
    }
  }
  return true;
}

// [1, 2, [3, 4]].equals([1, 2, [3, 2]]) === false;
// [1, "2,3"].equals([1, 2, 3]) === false;
// [1, 2, [3, 4]].equals([1, 2, [3, 4]]) === true;
// [1, 2, 1, 2].equals([1, 2, 1, 2]) === true;


Array.prototype.random = function (length) {
  return this[Math.floor((Math.random()*length))];
}

// var teams = ['patriots', 'colts', 'jets', 'texans', 'ravens', 'broncos']
// var chosen_team = teams.random(teams.length)
