% Find:
%
%   1. Some free Prolog tutorials
%
%   http://www.lix.polytechnique.fr/~liberti/public/computing/prog/prolog/prolog-tutorial.html
%   http://www.csupomona.edu/~jrfisher/www/prolog_tutorial/contents.html
%
%
%   2. A support forums (there are several)
%
%   http://old.nabble.com/SWI-Prolog-f448.html
%   http://mail.gnu.org/pipermail/users-prolog/
%   http://www.reddit.com/r/prolog
%
%
%   3. One online reference for the Prolog version you're using
%
%   http://www.gprolog.org/manual/gprolog.html

% Do:
%
%   1. Make a simple knowledge base. Represent some of your favorite books and
%   authors.

    book('The Name Of The Wind', 'Patrick Rothfuss').
    book('Anathem', 'Neal Stephenson').
    book('The Skystone', 'Jack Whyte').
    book('The Singing Sword', 'Jack Whyte').
    book('Rapid Development', 'Steve McConnell').
    book('The Pragmatic Programmer', 'Andy Hunt & Dave Thomas').
    book('Seven Languages In Seven Weeks', 'Bruce Tate').

%   2. Find all books in your knowledge base written by one author.

%   ?- book(What, 'Neal Stephenson').
%
%       What = 'Anathem' ? ;
%
%   ?- book(What, 'Jack White').
%
%       What = 'The Skystone' ? ;
%
%       What = 'The Singing Sword' ? ;

%

%   3. Make a knowledge base representing musicians and instruments. Also
%   represent musicians and their genre of music.

    musician_instrument('Hansi Kursch', vocals).
    musician_instrument('Hansi Kursch', bass).
    musician_instrument('Andre Olbrich', guitar).
    musician_instrument('Duke Ellington', piano).
    musician_instrument('Jimi Hendrix', guitar).

    musician_genre('Hansi Kurch', metal).
    musician_genre('Andre Olbrich', metal).
    musician_genre('Duke Ellington', jazz).
    musician_genre('Jimi Hendrix', rock).

%   4. Find all musicians who play the guitar.
%
%   ?- musician_instrument(What, guitar)
%
%       What = 'Andre Olbrich' ? ;
%
%       What = 'Jimi Hendrix'
