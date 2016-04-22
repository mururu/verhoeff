-module(verhoeff).

-export([checksum/1, encode/1, is_valid/1]).

-define(D, {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
            {1, 2, 3, 4, 0, 6, 7, 8, 9, 5},
            {2, 3, 4, 0, 1, 7, 8, 9, 5, 6},
            {3, 4, 0, 1, 2, 8, 9, 5, 6, 7},
            {4, 0, 1, 2, 3, 9, 5, 6, 7, 8},
            {5, 9, 8, 7, 6, 0, 4, 3, 2, 1},
            {6, 5, 9, 8, 7, 1, 0, 4, 3, 2},
            {7, 6, 5, 9, 8, 2, 1, 0, 4, 3},
            {8, 7, 6, 5, 9, 3, 2, 1, 0, 4},
            {9, 8, 7, 6, 5, 4, 3, 2, 1, 0}}).

-define(P, {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
            {1, 5, 7, 6, 2, 8, 3, 0, 9, 4},
            {5, 8, 0, 3, 7, 9, 6, 1, 4, 2},
            {8, 9, 1, 6, 0, 4, 3, 5, 2, 7},
            {9, 4, 5, 3, 1, 2, 6, 8, 7, 0},
            {4, 2, 8, 6, 5, 7, 3, 9, 0, 1},
            {2, 7, 9, 3, 8, 0, 6, 4, 1, 5},
            {7, 0, 4, 6, 9, 1, 3, 2, 5, 8}}).

-define(INV, {0, 4, 3, 2, 1, 5, 6, 7, 8, 9}).

-spec checksum(binary() | list() | non_neg_integer()) -> 0..9.
checksum(Bin) when is_binary(Bin) ->
    checksum_bin(Bin, 1);
checksum(S) when is_list(S) ->
    checksum_list(S, 1);
checksum(N) when is_integer(N) ->
    S = integer_to_list(N),
    checksum_list(S, 1).

%% TODO: optimize
checksum_bin(Bin, Offset) ->
    lookup_inv(checksum_list(lists:reverse(binary_to_list(Bin)), Offset, 0)).

checksum_list(S, Offset) ->
    lookup_inv(checksum_list(lists:reverse(S), Offset, 0)).

checksum_list([C|Rest], I, Acc) ->
    checksum_list(Rest, I + 1, ?LOOKUP(Acc, C - 48, I));
checksum_list([], _, Acc) ->
    Acc.

lookup(Acc, C, I) ->
    element(element(C + 1, element((I rem 8) + 1, ?P)) + 1, element(Acc + 1, ?D)).

lookup_inv(I) ->
    element(I + 1, ?INV).

-spec encode(binary() | list() | non_neg_integer()) -> binary() | list() | non_neg_integer().
encode(Bin) when is_binary(Bin) ->
    <<Bin/binary, (checksum_bin(Bin, 1) + 48)>>;
encode(S) when is_list(S) ->
    S ++ [checksum_list(S, 1) + 48];
encode(N) when is_integer(N) ->
    S = integer_to_list(N),
    10 * N + checksum_list(S, 1).

-spec is_valid(binary() | list() | non_neg_integer()) -> boolean().
is_valid(Bin) when is_binary(Bin)->
    checksum_bin(Bin, 0) == 0;
is_valid(S) when is_list(S)->
    checksum_list(S, 0) == 0;
is_valid(N) when is_integer(N)->
    S = integer_to_list(N),
    checksum_list(S, 0) == 0.

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

checksum_test_() ->
    [?_assertEqual(3, checksum(236)),
     ?_assertEqual(3, checksum("236")),
     ?_assertEqual(3, checksum(<<"236">>))].

encode_test_() ->
    [?_assertEqual(2363, encode(236)),
     ?_assertEqual("2363", encode("236")),
     ?_assertEqual(<<"2363">>, encode(<<"236">>))].

is_valid_test_() ->
    [?_assertEqual(true, is_valid(2363)),
     ?_assertEqual(true, is_valid("2363")),
     ?_assertEqual(true, is_valid(<<"2363">>))].

-endif.
