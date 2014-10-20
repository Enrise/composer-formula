install-curl:
  pkg.installed:
    - name: curl

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - require:
      - pkg: curl

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

{% if 'install_dirs' in salt['pillar.get']('composer', {}) %}
{% for install_dir in salt['pillar.get']('composer:install_dirs', {}) %}
composer-install-{{ install_dir }}: # This is only here for a unique name.
  cmd.run:
    - name: 'composer install --prefer-dist --no-interaction'
    - cwd: {{ install_dir }}
    - unless: test -d {{ install_dir }}/vendor
    - require:
      - cmd: get-composer
{% endfor %}
{% endif %}
