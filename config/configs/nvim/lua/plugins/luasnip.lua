local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets('dart', {
  s('DomComponent', {
    t 'var ',
    i(1),
    t '= DomComponent(tag: ',
    i(2),
    t 'styles: Styles.text(color: Colors.blue),',
    t "child: Text('Hello World!'),",
    t ');',
  }),
})
