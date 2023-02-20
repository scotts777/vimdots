vim9script

plug#begin()
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'yegappan/lsp'
plug#end()

set termguicolors
syntax on
colorscheme acme

set mouse=a
set cursorline
set relativenumber
g:mapleader = ","
imap jk <esc>

var lspServers = [ {
		      filetype: ['clojure', 'edn'],
                      path: 'clojure-lsp', 
                      args: []},

                    {filetype: 'vim',
		     path: '/usr/local/bin/vim-language-server',
		     args: ['--stdio']}]

autocmd VimEnter * call LspAddServer(lspServers)
var lspOpts = {'autoHighlightDiags': v:true}
autocmd VimEnter * call LspOptionsSet(lspOpts)

nmap <Leader>h :LspHover<CR>
nmap <Leader>ca :LspCodeAction<CR>
nmap <Leader>dc :LspDiagCurrent<CR>
nmap <Leader>df :LspDiagFirst<CR>
nmap <Leader>dd :LspDiagHighlightDisable<CR>
nmap <Leader>de :LspDiagHighlightEnable<CR>
nmap <Leader>dn :LspDiagNext<CR>
nmap <Leader>dp :LspDiagPrev<CR>
nmap <Leader>ds :LspDiagShow<CR>
nmap <Leader>fd :LspFold<CR>
nmap <Leader>ft :LspFormat<CR>
nmap <Leader>gdl :LspGotoDeclaration<CR>
nmap <Leader>gdf :LspGotoDefinition<CR>
nmap <Leader>gi :LspGotoImpl<CR>
nmap <Leader>hl :LspHighlight<CR>
nmap <Leader>hlc :LspHighlightClear<CR>
nmap <Leader>ic :LspIncomingCalls<CR>
nmap <Leader>oc :LspOutgoingCalls<CR>
nmap <Leader>ol :LspOutline<CR>
nmap <Leader>pdl :LspPeekDeclaration<CR>
nmap <Leader>pdf :LspPeekDefinition<CR>
nmap <Leader>pim :LspPeekImpl<CR>
nmap <Leader>pr  :LspPeekReferences<CR>
nmap <Leader>rn :LspRename<CR>
nmap <Leader>se :LspSelectionExpand<CR>
nmap <Leader>ss :LspSelectionShrink<CR>
nmap <Leader>sr :LspShowReferences<CR>
nnoremap <Leader>lf :call SendToTerminal(GetLoadFileCommand())<CR>
nnoremap <Leader>in :call SendToTerminal(InNameSpace())<CR>
nnoremap <Leader>ef :call SendToTerminal(GetForm())<CR>
nnoremap <Leader>et :call SendToTerminal(GetTopForm())<CR>
vnoremap <Leader>es :call SendToTerminal(GetSelection())<CR>

def FirstTerminalIDInTab(): number
   var buffers = tabpagebuflist()
   for i in buffers
	   var buffType = getbufvar(i, '&buftype', 'ERROR')
	   if buffType == "terminal"
		   return i
	   endif
   endfor
   return -1
enddef

def g:SendToTerminal(toSend: string)
   var terminalBuffID = FirstTerminalIDInTab()
   if terminalBuffID == -1
      echo "No terminal buffer in tab"
   else
     var completeCommand = toSend .. "\<CR>"
     term_sendkeys(terminalBuffID, completeCommand)
   endif
enddef

def g:GetLoadFileCommand(): string
   var relativePath = expand("%")
   var loadFile = "(load-file \"" .. relativePath .. "\")"
   return loadFile
enddef

def g:InNameSpace(): string
   var savePosition = getpos(".")
   var searchPos = searchpos('(ns \S*', 'n')
   var lineText = getline(searchPos[0])
   var startText = lineText[searchPos[1] + 3 : ]
   var textSplit = split(startText)
   var nameSpace = textSplit[0]
  var inNameSpace = "(in-ns '" .. nameSpace .. ")"
   return inNameSpace
enddef

def g:GetForm(): string
   norm "ayaf
   return @a 
enddef

def g:GetTopForm(): string
   norm "ayaF
   return @a 
enddef

def g:GetSelection(): string
   norm "ay
   return @a 
enddef



