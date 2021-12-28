#lang racket/base

(provide out
         (all-from-out racket/file))

(require
  racket/port
  racket/string
  racket/file
  racket/path
  scribble/text/output)

(define (out content file-path)
  (let* ([fname (file-name-from-path file-path)]
         [name (path->string fname)]
         [new-name (string-append ".last_" name)]
         [new-path (string-replace file-path name new-name)]) 
    (cond
      [(file-exists?  file-path) (rename-file-or-directory file-path new-path #t)]
      [else (make-parent-directory* file-path)]))

  (define outport (open-output-file file-path #:exists 'replace))
  (output  content outport)
  (close-output-port outport)
  (fprintf (current-output-port) "generated file at -> ~a" file-path))