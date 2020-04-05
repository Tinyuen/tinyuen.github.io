{%
  set js_commons = [
    '//cdn.jsdelivr.net/gh/Tinyuen/blogcdn@0.0.1/js/utils.min.js',
    '//cdn.jsdelivr.net/gh/Tinyuen/blogcdn@0.0.1/js/motion.min.js'
  ]
%}

{% for common in js_commons %}
  <!--  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ common }}?v={{ theme.version }}"></script>-->
  <script type="text/javascript" src="{{ common }}"></script>
{% endfor %}
