{%
  set boot_scripts = [
    '//cdn.jsdelivr.net/gh/Tinyuen/blogcdn@0.0.1/js/bootstrap.min.js'
  ]
%}

{% for bs in boot_scripts %}
  <!--  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ bs }}?v={{ theme.version }}"></script>-->
  <script type="text/javascript" src="{{ bs }}"></script>
{% endfor %}
