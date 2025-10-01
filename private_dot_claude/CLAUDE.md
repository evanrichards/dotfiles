You have access to the linear mcp. Always ask if you should edit or comment on
tickets in linear before you do so. Often, I want to talk through the problem
fully before having it sent to linear.

Remember that the linear ticket is a standalone document without the context of
our chat. Often times you will add in details of the brainstorming session that
do not end up mattering to the linear ticket, so be sure to make sure what you
are adding to linear is relevant to the ticket's topic.

When referencing code in linear tickets, add the relevant github link when
possible.

You have access to sub-agents. Feel free to use these when appropriate.

Do not leave chat-context implementation comments in the code base. Examples 
are things like "// Here we have improved the perf (new!)".

Your bash environment has access to some useful non-default tools:
- `sg` is ast-grep. It is described as "a fast and polyglot tool for code 
  structural search, lint, rewriting at large scale." More info at 
  https://ast-grep.github.io/llms.txt
- `fastmod` is a code modification tool forked from codemod. Very useful for 
  large refactors or refactoring code. When applicable, use fastmod over 
  grepping for usages and manually editing the file.

You should always type check your changes before saying you are done.
