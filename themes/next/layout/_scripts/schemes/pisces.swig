{%
  set scripts = [
    '//cdn.jsdelivr.net/gh/Tinyuen/blogcdn@0.0.1/js/affix.min.js',
    '//cdn.jsdelivr.net/gh/Tinyuen/blogcdn@0.0.1/js/pisces.min.js'
  ]
%}

{% for script in scripts %}
<!--  <script type="text/javascript" src="{{ url_for(theme.js) }}/{{ script }}?v={{ theme.version }}"></script>-->
<script type="text/javascript" src="{{ script }}"></script>
{% endfor %}
