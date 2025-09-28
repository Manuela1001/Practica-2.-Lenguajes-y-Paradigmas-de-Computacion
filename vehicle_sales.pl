% vehicle(Brand, Reference, Type, Price, Year)

vehicle(toyota, corolla,   sedan, 22000, 2023).
vehicle(toyota, rav4,  	suv,   28000, 2022).
vehicle(toyota, hilux, 	pickup,35000, 2021).
vehicle(ford,   mustang,   sport, 45000, 2023).
vehicle(ford,   explorer,  suv,   40000, 2022).
vehicle(ford,   ranger,	pickup,32000, 2021).
vehicle(bmw,	x5,    	suv,   60000, 2021).
vehicle(bmw,	m3,    	sport, 70000, 2022).
vehicle(honda,  civic, 	sedan, 24000, 2024).
vehicle(honda,  pilot, 	suv,   33000, 2022).
vehicle(chevy,  silverado, pickup,37000, 2023).
vehicle(mazda,  mx5,   	sport, 30000, 2024).
vehicle(honda, crv,     suv, 27000, 2023).
vehicle(honda, hrv,     suv, 15000, 2021).
vehicle(honda, pilot,   suv, 57000, 2020).

meet_budget(Reference, BudgetMax) :- 
	vehicle(_, Reference, _, Price, _) ,
	Price =< BudgetMax.

vehicles_brand(Brand, References) :- 
	findall(Reference, vehicle(Brand, Reference, _, _, _ ), References).

generate_report(Brand, Type, Budget, report(Selected, Total)) :-
    findall((Ref, Price, Year),
        ( vehicle(Brand, Ref, Type, Price, Year),
          Price =< Budget
        ),
        Candidates),
    sort(2, @=<, Candidates, Sorted),
    pick_budget(Sorted, Budget, Selected, Total).

pick_budget([], _, [], 0).
pick_budget([(R,P,Y)|Other], Budget, [(R,P,Y)|Chosen], Total) :-
    P =< Budget,
    NewBudget is Budget - P,
    pick_budget(Other, NewBudget, Chosen, SubTotal),
    Total is SubTotal + P.
pick_budget([(_,P,_)|Other], Budget, Chosen, Total) :-
    P > Budget,
    pick_budget(Other, Budget, Chosen, Total).

case_1(Result) :- 
	findall(Ref, (vehicle(toyota, Ref, suv, Price, _), Price < 30000), Result). 

case_2(Result) :- 
	bagof((Type, Year, Ref), 
	vehicle(ford, Ref, Type, _, Year), Result).

case_3(Result) :- 
	findall(Price, vehicle(_, _, sedan, Price, _), Prices),
	sum_list(Prices, Sum),
	(Sum =< 500000 -> Result = Sum ; Result = 'Exceeds limit').
