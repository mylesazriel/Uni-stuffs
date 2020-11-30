% QUESTION 1 -----------------------------------------------------

/* Predicate: station(StationName, ListOfLines),
   where StationName is in the list ListOfLines. 
*/

% Bakerloo Line
station('EC', ['Bakerloo']). 
station('EM', ['Bakerloo', 'Northern']).
station('OC', ['Bakerloo', 'Central', 'Victoria']).
station('PA', ['Bakerloo']).
station('WA', ['Bakerloo']).

% Central Line
station('BG', ['Central']).
station('LS', ['Central', 'Metropolitan']).
station('CL', ['Central']).
station('TC', ['Central', 'Northern']).
station('LG', ['Central']).
station('NH', ['Central']).

% Metropolitan Line
station('AL', ['Metropolitan']).
station('KX', ['Metropolitan', 'Victoria']).
station('BS', ['Metropolitan']).
station('FR', ['Metropolitan']).

% Northern Line
station('KE', ['Northern']).
station('WS', ['Northern', 'Victoria']).
station('EU', ['Northern']).

% Victoria Line
station('BR', ['Victoria']).
station('VI', ['Victoria']).
station('FP', ['Victoria']).


% QUESTION 2 -----------------------------------------------------

/* Calls the predicate: station(StationName, ListOfLines), 
   the '_' is 'any term' and checks each list for Station. 
*/ 

station_exists(Station) :- 
	station(Station, _).

/* TEST CASES:
   Station exists:
   ?-station_exists('WA').
   true. 

   Station does not exist:   
   ?-station_exists('A').
   false.
*/


% QUESTION 3 -----------------------------------------------------

/* Predicate: adjacent(Station1, Station2),
   where Station1 and Station2 are adjacent.
   Listed going in either direction. 
*/

% Adjacencies for Bakerloo
adjacent('EC', 'EM').
adjacent('EM', 'EC').
adjacent('EM', 'OC').
adjacent('OC', 'EM').
adjacent('OC', 'PA').
adjacent('PA', 'OC').
adjacent('PA', 'WA').
adjacent('WA', 'PA').

% Adjacencies for Central
adjacent('BG', 'LS').
adjacent('LS', 'BG').
adjacent('LS', 'CL').
adjacent('CL', 'LS').
adjacent('CL', 'TC').
adjacent('TC', 'CL').
adjacent('TC', 'OC').
adjacent('OC', 'TC').
adjacent('OC', 'LG').
adjacent('LG', 'OC').
adjacent('LG', 'NH').
adjacent('NH', 'LG').

% Adjacencies for Metropolitan
adjacent('AL', 'LS').
adjacent('LS', 'AL').
adjacent('LS', 'KX').
adjacent('KX', 'LS').
adjacent('KX', 'BS').
adjacent('BS', 'KX').
adjacent('BS', 'FR').
adjacent('FR', 'BS').

% Adjacencies for Northern
adjacent('KE', 'EM').
adjacent('EM', 'KE').
adjacent('EM', 'TC').
adjacent('TC', 'EM').
adjacent('TC', 'WS').
adjacent('WS', 'TC').
adjacent('WS', 'EU').
adjacent('EU', 'WS').

% Adjacencies for Victoria
adjacent('BR', 'VI').
adjacent('VI', 'BR').
adjacent('VI', 'OC').
adjacent('OC', 'VI').
adjacent('OC', 'WS').
adjacent('WS', 'OC').
adjacent('WS', 'KX').
adjacent('KX', 'WS').
adjacent('KX', 'FP').
adjacent('FP', 'KX').


% QUESTION 4 -----------------------------------------------------

/* Checks if two stations are on the same line:
	station(Station, ListOfLines) creates a list
	of all lines that the Station stated is in.

	intersection(ListOfLines1, ListOfLines2, [Line|_])
	compares both lists and creates its own list of all
	common variables i.e. which lines are present in both.
	[Line|_] is just for formatting.

	sameline(Station1, Station2, Line) then: 
   	returns false if there is no common line,
   	returns Line if there is a common line. 
*/

sameline(Station1, Station2, Line) :-
	station(Station1, ListOfLines1),
	station(Station2, ListOfLines2),
	intersection(ListOfLines1, ListOfLines2, [Line|_]).
	
/* TEST CASES:
   Common Line found:
   ?-sameline('WA', 'EC', Line).
   Line = 'Bakerloo'.

   No common Line:
   ?-sameline('FP', 'KE', Line).   
   false.

   Station does not exist:
   ?-sameline('NotAStation', 'KE', Line).
   false.
   ?-sameline('FP', 'NotAStation', Line).
   false.
*/


% QUESTION 5 -----------------------------------------------------

/* Finds all the stations on a given line:
	findall collects a list StationLine that consists of
	all items Station that satisfy the backtrackable goal:
	(station(Station, StationLine), member(Line, StationLine)),
	which contains all the results of Station and binds Line as a
	member of StationLine so all stations within are checked.
*/


line(Line, ListOfStations) :-
	findall(Station, (station(Station, StationLine), 
	member(Line, StationLine)), ListOfStations).

/* TEST CASES:
   Line exists, in this case 'Victoria':
   ?- line('Victoria', ListOfStations).
   ListOfStations = ['BR', 'VI', 'OC', 'WS', 'KX', 'FP'].

   Line does not exist:
   ?-line('NotALine', ListOfStations).
   ListOfStations = [].
*/


% QUESTION 6 -----------------------------------------------------

/* Finds how many lines run through a station:
	station(Station, Line) finds the list of lines 
	a station is on and passes that to length,
	length(Line, NumberOfLines) then displays the 
	length of Line as NumberOfLines.
*/

station_numlines(Station, NumberOfLines) :- 
	station(Station, Line),
	length(Line, NumberOfLines).

/* TEST CASES:
   Station exists, in this case it has three lines:
   ?-station_numlines('OC', NumberOfLines).
   NumberOfLines = 3.

   Station does not exist:
   ?-station_numlines('NotAStation', NumberOfLines).
   false.
*/


% QUESTION 7 -----------------------------------------------------

/* This checks if there are any interchanges next to a station: 
	The rule returns true if:
	NumOfLinesX > 1 AND length(LineListX, NumOfLinesX) == Length of InterchangeStation
	OR
	NumOfLinesY ==1 AND length(LineListY, NumOfLinesY) == Length of NonInterStation
	
	Otherwise the rule returns false.
*/	

adjacent2interchange(NonInterStation, InterchangeStation) :-
	station(InterchangeStation, LineListX), 
	length(LineListX, NumOfLinesX),
	NumOfLinesX > 1,
	station(NonInterStation, LineListY), 
	length(LineListY, NumOfLinesY),
	NumOfLinesY == 1,
	adjacent(NonInterStation, InterchangeStation).

/* TEST CASES:
   Interchange chosen:
   ?-adjacent2interchange('OC', InterchangeStation).
   false.

   Non Interchange chosen, this case has two adjacent interchanges:
   ?-adjacent2interchange('CL', InterchangeStation).
   InterchangeStation = 'LS';
   InterchangeStation = 'TC';
   false.

   Station does not exist:
   ?-adjacent2interchange('NotAStation', InterchangeStation).
   false.
*/


% QUESTION 8 -----------------------------------------------------

% This rule finds the route between two stations:

route(From, To, Route) :- 			% Finds the route between two stations
	findroute(From, To, [], RouteReverse),  % Reverse allows it to look back at its journey
	reverse([To|RouteReverse], Route).
	
findroute(From, To, Temporary, Route) :- 	% Temporary holds current list of stations
	adjacent(From, To), 			% Checks that the stations are adjacent 
	\+member(From, Temporary), 		% \+ means that if it is unsure, assumes false
	Route = [From|Temporary]. 

findroute(From, To, Temporary, Route) :- 	% The recursive rule, called when 'From' and 'To' are not adjacent
	adjacent(From, Next), 			% Checks for the next adjacent station not picked before
	Next \== To, 				% Checks next station to make sure it is not the same and continues if true
	\+member(From, Temporary),
	findroute(Next, To, [From|Temporary], Route). 	% Adds station to Temporary and process repeats


/* TEST CASES:
   Many routes:
   ?-route('TC', 'CL', Route).
   Route = ['TC', 'CL'];
   Route = ['TC', 'EM', 'OC', 'WS', 'KX', 'LS', 'CL'];
   Route = ['TC', 'OC', 'WS', 'KX', 'LS', 'CL'];
   Route = ['TC', 'WS', 'KX', 'LS', 'CL'];
   false. 
   
   One route:
   ?-route('OC', 'NH', Route).
   Route = ['OC', 'LG', 'NH'];
   false.

   If a station does not exist:
   ?-route('NotAStation', 'EU', Route).
   false.
   ?-route('EU', 'NotAStation', Route).
   false.
   ?-route('NotAStation', 'NotAStation', Route).
   false.
*/


% QUESTION 9 -----------------------------------------------------

/* This rule calculates the length of a journey:
	length(Route, Time) gets how many stations the train passes
	RouteTime then does (Number of stations - 1) * 4 to get journey time.
*/

route_time(From, To, Route, Minutes) :-
	route(From, To, Route),
	length(Route, Time),
        Minutes is (Time - 1) * 4.

/* TEST CASES:
   Route exists, with multiple routes:
   ?-route_time('FR', 'OC', Route, Minutes).
   Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'OC'],
   Minutes = 24 ;
   Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'EM', 'OC'],
   Minutes = 28 ;
   Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'WS', 'OC'],
   Minutes = 28 ;
   Route = ['FR', 'BS', 'KX', 'WS', 'OC'],
   Minutes = 16 ;
   Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'OC'],
   Minutes = 20 ;
   Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'EM', 'OC'],
   Minutes = 24 ;
   false.
   
   Route exists, with one route:
   ?-route_time('BR', 'VI', Route, Minutes).
   Route = ['BR', 'VI'],
   Minutes = 4;
   false.

   Station does not exist:
   ?-route_time('NotAStation', 'EU', Route, Minutes).
   false.
   ?-route_time('EU', 'NotAStation', Route, Minutes).
   false.
   ?-route_time('NotAStation', 'NotAStation', Route, Minutes).
   false.
*/
   
   
