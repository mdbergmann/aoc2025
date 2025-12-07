using Test

test_1_input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

function strtoarr(input)
    line_sep_input = split(input, "\n", keepempty=false)
    map(x -> (first(x), parse(Int, Base.rest(x, 2))), line_sep_input)
end

test_1_input_arr = strtoarr(test_1_input)

println(test_1_input_arr)

@test first(test_1_input, 3) == "L68"
@test ! isempty(test_1_input_arr)
@test test_1_input_arr[2][1] == 'L'
@test test_1_input_arr[2][2] == 30

function calc(input)
    result = 0
    dial = 50
    for t in input
	    if t[1] == 'L'
            dial -= t[2]
        else
            dial += t[2]
        end
        dial = mod(dial, 100)
        if dial < 0
            dial = 100 - -1*dial
        elseif dial > 100
            dial = 0 + (dial - 100)
        elseif dial == 100
            dial = 0
        end

        if dial == 0
            result += 1
        end
    end
    return result
end

@test calc(test_1_input_arr) == 3

function calc2(input)
    result = 0
    dial = 50
    for t in input
        # Calculate zero crossings during rotation (excluding final position)
        if t[1] == 'L'
            # For left rotation, count crossings in open interval (dial - amount, dial)
            result += fld(dial - 1, 100) - fld(dial - t[2], 100)
            dial -= t[2]
        else
            # For right rotation, count crossings in open interval (dial, dial + amount)
            result += fld(dial + t[2] - 1, 100) - fld(dial, 100)
            dial += t[2]
        end
        #println("In: ", t, ", Dial: ", dial, ", result: ", result)
        dial = mod(dial, 100)
        if dial < 0
            dial = 100 - abs(dial)
        elseif dial > 100
            dial = 0 + (dial - 100)
        elseif dial == 100
            dial = 0
        end

        if dial == 0
            result += 1
        end
    end
    return result
end

@test calc2(test_1_input_arr) == 6

input = read("day1_input.txt", String)
input_arr = strtoarr(input)
result = calc(input_arr)
println("result: ", result)
@test result == 1177

result2 = calc2(input_arr)
println("result2: ", result2)
@test result2 == 6768
