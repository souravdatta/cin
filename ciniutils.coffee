# URL match utilities for Cinister
# Copyright (c) Sourav Datta, soura.jagat@gmail.com (2013)

exports.slice_string = (str) ->
  if str[0] != '/'
    str = '/' + str
  if str[str.length - 1] != '/'
    str = str + '/'
  str.split('/').slice(1, -1)

exports.star_match = (pattern, str) ->
  pattern = pattern.replace(/\./g, '\\.');
  pattern = pattern.replace(/\*/g, '.*');
  pattern = '^' + pattern + '$';
  str.match(new RegExp pattern)
    
exports.match_url = (pattern, url, mapping = {}) ->
  if pattern.length != url.length
    return [false, mapping]
    
  if pattern.length == 0
    return [true, mapping]
  
  if pattern[0] == url[0]
    # literal match, do nothing
  else if (pattern[0][0] == ':') and (pattern[0].length > 1)
    # A mand parameter
    mapping[pattern[0].slice(1)] = url[0]
  else if exports.star_match(pattern[0], url[0])
    # A star match
    if mapping['splat']
      mapping['splat'].push url[0]
    else
      mapping['splat'] = [url[0]]
  else
    return [false, mapping]
  
  return exports.match_url pattern.slice(1), url.slice(1), mapping 
