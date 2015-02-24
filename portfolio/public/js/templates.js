!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.templates=e()}}(function(){var define,module,exports;
!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var n;"undefined"!=typeof window?n=window:"undefined"!=typeof global?n=global:"undefined"!=typeof self&&(n=self),n.jade=e()}}(function(){return function e(n,t,r){function o(a,f){if(!t[a]){if(!n[a]){var s="function"==typeof require&&require;if(!f&&s)return s(a,!0);if(i)return i(a,!0);var u=new Error("Cannot find module '"+a+"'");throw u.code="MODULE_NOT_FOUND",u}var l=t[a]={exports:{}};n[a][0].call(l.exports,function(e){var t=n[a][1][e];return o(t?t:e)},l,l.exports,e,n,t,r)}return t[a].exports}for(var i="function"==typeof require&&require,a=0;a<r.length;a++)o(r[a]);return o}({1:[function(e,n,t){"use strict";function r(e){return null!=e&&""!==e}function o(e){return(Array.isArray(e)?e.map(o):e&&"object"==typeof e?Object.keys(e).filter(function(n){return e[n]}):[e]).filter(r).join(" ")}t.merge=function i(e,n){if(1===arguments.length){for(var t=e[0],o=1;o<e.length;o++)t=i(t,e[o]);return t}var a=e["class"],f=n["class"];(a||f)&&(a=a||[],f=f||[],Array.isArray(a)||(a=[a]),Array.isArray(f)||(f=[f]),e["class"]=a.concat(f).filter(r));for(var s in n)"class"!=s&&(e[s]=n[s]);return e},t.joinClasses=o,t.cls=function(e,n){for(var r=[],i=0;i<e.length;i++)r.push(n&&n[i]?t.escape(o([e[i]])):o(e[i]));var a=o(r);return a.length?' class="'+a+'"':""},t.style=function(e){return e&&"object"==typeof e?Object.keys(e).map(function(n){return n+":"+e[n]}).join(";"):e},t.attr=function(e,n,r,o){return"style"===e&&(n=t.style(n)),"boolean"==typeof n||null==n?n?" "+(o?e:e+'="'+e+'"'):"":0==e.indexOf("data")&&"string"!=typeof n?(-1!==JSON.stringify(n).indexOf("&")&&console.warn("Since Jade 2.0.0, ampersands (`&`) in data attributes will be escaped to `&amp;`"),n&&"function"==typeof n.toISOString&&console.warn("Jade will eliminate the double quotes around dates in ISO form after 2.0.0")," "+e+"='"+JSON.stringify(n).replace(/'/g,"&apos;")+"'"):r?(n&&"function"==typeof n.toISOString&&console.warn("Jade will stringify dates in ISO form after 2.0.0")," "+e+'="'+t.escape(n)+'"'):(n&&"function"==typeof n.toISOString&&console.warn("Jade will stringify dates in ISO form after 2.0.0")," "+e+'="'+n+'"')},t.attrs=function(e,n){var r=[],i=Object.keys(e);if(i.length)for(var a=0;a<i.length;++a){var f=i[a],s=e[f];"class"==f?(s=o(s))&&r.push(" "+f+'="'+s+'"'):r.push(t.attr(f,s,!1,n))}return r.join("")},t.escape=function(e){var n=String(e).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");return n===""+e?e:n},t.rethrow=function a(n,t,r,o){if(!(n instanceof Error))throw n;if(!("undefined"==typeof window&&t||o))throw n.message+=" on line "+r,n;try{o=o||e("fs").readFileSync(t,"utf8")}catch(i){a(n,null,r)}var f=3,s=o.split("\n"),u=Math.max(r-f,0),l=Math.min(s.length,r+f),f=s.slice(u,l).map(function(e,n){var t=n+u+1;return(t==r?"  > ":"    ")+t+"| "+e}).join("\n");throw n.path=t,n.message=(t||"Jade")+":"+r+"\n"+f+"\n\n"+n.message,n}},{fs:2}],2:[function(){},{}]},{},[1])(1)});return {"project": function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (props, undefined) {
buf.push("<div" + (jade.attr("style", (props.background ? "background-image: url("+props.path+props.background+")" : "background-image: url(http://lorempixel.com/400/500/abstract/)"), true, false)) + " class=\"content--project\"><div class=\"content--title\">" + (jade.escape(null == (jade_interp = props.title) ? "" : jade_interp)) + "</div><div class=\"content--container\"><div class=\"description\"> <h2>Description</h2><div>" + (((jade_interp = props.content) == null ? '' : jade_interp)) + "</div></div><div class=\"images\">");
if ( props.images)
{
if ( props.images.length === 1)
{
buf.push("<h2>Image</h2><img" + (jade.attr("src", props.path+props.images[0], true, false)) + " alt=\"\"/>");
}
else
{
buf.push("<h2>Images</h2><div class=\"slider\">");
// iterate props.images
;(function(){
  var $$obj = props.images;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var i = $$obj[$index];

buf.push("<img" + (jade.attr("src", props.path+i, true, false)) + " alt=\"\"/>");
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var i = $$obj[$index];

buf.push("<img" + (jade.attr("src", props.path+i, true, false)) + " alt=\"\"/>");
    }

  }
}).call(this);

buf.push("</div>");
}
}
buf.push("<hr/><h2>Meta</h2><table><tr><th>year</th><td>" + (jade.escape(null == (jade_interp = props.date) ? "" : jade_interp)) + "</td></tr>");
if ( !props.background)
{
buf.push("<tr><th>background</th><td>lorempixel.com</td></tr>");
}
buf.push("</table><hr/></div></div></div>");}.call(this,"props" in locals_for_with?locals_for_with.props:typeof props!=="undefined"?props:undefined,"undefined" in locals_for_with?locals_for_with.undefined:typeof undefined!=="undefined"?undefined:undefined));;return buf.join("");
}};
});