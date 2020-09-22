# Resume

Produce a CV in any format you like using Jinja2 templates.
See my [blog entry](http://wtbarnes.github.io/2016/08/28/cv-howto/) about developing and using this method for building my CV.
I've now switched to using [AwesomeCV](https://github.com/posquit0/Awesome-CV) for generating the LaTeX/PDF version.

The templates included in `templates/` are for:

* markdown
* HTML
* LaTeX (including a shortened 1 page version)

To build every version,

```shell
make
```

This requires Python 3.6+, Jinja2, and PyYaml.
