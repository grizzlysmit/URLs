#!/usr/bin/env raku
use v6;

use Urls;

multi sub MAIN('list', 'links', Str $prefix = '') returns Int {
   if list-links($prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'aliases', Str $prefix = '') returns Int {
   if list-aliases($prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('list', 'pages', Str $page-name = '', Str $prefix = '') returns Int {
   if list-pages($page-name, $prefix) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'page', Str $page where { $page !~~ rx/^^ \s+ $$/ }, Str :$name = '', *@links) returns Int {
   if add-page($page, $name, @links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'links', Str $link-section where { $link-section !~~ rx/^^ \s+ $$/ }, *%links where { %links }) returns Int {
   if add-links($link-section, %links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'alias', Str $alias-name where { $alias-name !~~ rx/^^ \s* $$/ && (!section-exists($alias-name) || alias-exists($alias-name)) }, Str $link-section where { $link-section !~~ rx/^^ \s* $$/ && (link-exists($link-section) || alias-exists($link-section))  }) returns Int {
   if add-alias($alias-name, $link-section) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'links', Str $link-section where { $link-section !~~ rx/^^ \s+ $$/ },  Bool :r(:$remove-section) = False, *@links where { @links }) returns Int {
   if delete-links($link-section, $remove-section, @links) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'page', Str $page-name where { $page-name !~~ rx/^^ \s+ $$/ }) returns Int {
   if delete-page($page-name) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('delete', 'pseudo-page', Str $page-name where { $page-name !~~ rx/^^ \s+ $$/ }) returns Int {
   if delete-pseudo-page($page-name) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('add', 'pseudo-page', Str $page where { $page !~~ rx/^^ \s+ $$/ }, Str $pattern = '', Str :$status where { $status ~~ rx/^^ ['invalid'|'unassigned'|'assigned'|'both'] $$/ } = 'invalid', Str :$full-name = $page) returns Int {
   if add-pseudo-pages($page, Str2Status($status), $full-name, $pattern) {
       exit 0;
   } else {
       exit 1;
   } 
}

multi sub MAIN('launch', 'link', Str $section where { $section !~~ rx/^^ \s+ $$/ }, Str $link) returns Int {
   if launch-link($section, $link) {
       exit 0;
   } else {
       exit 1;
   } 
}
