" My own custom airline theme


" Normal mode                                    " fg             & bg
let s:N1 = [ '#bcbcbc' , '#080808' , 250  , 232 ]
let s:N2 = [ '#88a671' , '#303030' , 108 , 236 ]
let s:N3 = [ '#ffffff' , '#121212' , 231 , 233 ]

" Insert mode                                    " fg             & bg
let s:I1 = [ '#fed7b1' , '#080808' , 223  , 232 ]
let s:I2 = [ '#88a671' , '#303030' , 108  , 236  ]
let s:I3 = [ '#ffffff' , '#121212' , 231 , 233  ]

" Visual mode                                    " fg             & bg
let s:V1 = [ '#080808' , '#fed7b1' , 232 , 223 ]

" Replace mode                                   " fg             & bg
let s:RE = [ '#fed7d8' , '#080808' , 224 , 233 ]

let g:airline#themes#easyburn#palette = {}

let g:airline#themes#easyburn#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#easyburn#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#easyburn#palette.insert_replace = {
      \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#easyburn#palette.visual = {
      \ 'airline_a': [ s:V1[0]   , s:V1[1]   , s:V1[2]   , s:V1[3]   , ''     ] }

let g:airline#themes#easyburn#palette.replace = copy(airline#themes#easyburn#palette.normal)
let g:airline#themes#easyburn#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]


let s:IA = [ s:N2[0] , s:N3[1] , s:N2[2] , s:N3[3] , '' ]
let g:airline#themes#easyburn#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

let g:airline#themes#easyburn#palette.accents = {
       \ 'red': [ '#e89a94' , '' , 174 , '' , '' ]
       \ }

" Warnings
let g:airline#themes#easyburn#palette.normal.airline_warning = [
            \ '#d6a490', '#303030', 181, 236
            \ ]

" Errors
let g:airline#themes#easyburn#palette.normal.airline_error = [
            \ '#e89a94', '#080808', 174, 232
            \ ]

