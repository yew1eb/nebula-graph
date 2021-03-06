# Copyright (c) 2020 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License,
# attached with Common Clause Condition 1.0, found in the LICENSES directory.
@delete_v_int
Feature: Delete int vid of vertex

  Background: Prepare space
    Given load "nba_int_vid" csv data to a new space

  Scenario: delete int vid vertex
    # get vertex info
    When executing query:
      """
      GO FROM hash("Boris Diaw") OVER like
      """
    Then the result should be, in any order:
      | like._dst           |
      | hash("Tony Parker") |
      | hash("Tim Duncan")  |
    When executing query:
      """
      GO FROM hash("Tony Parker") OVER like REVERSELY
      """
    Then the result should be, in any order:
      | like._dst                 |
      | hash("LaMarcus Aldridge") |
      | hash("Boris Diaw")        |
      | hash("Dejounte Murray")   |
      | hash("Marco Belinelli")   |
      | hash("Tim Duncan")        |
    # get value by fetch
    When executing query:
      """
      FETCH PROP ON player hash("Tony Parker") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID            | player.name   | player.age |
      | hash("Tony Parker") | "Tony Parker" | 36         |
    # check value by fetch
    When executing query:
      """
      FETCH PROP ON serve hash("Tony Parker")->hash("Spurs") YIELD serve.start_year, serve.end_year
      """
    Then the result should be, in any order:
      | serve._src          | serve._dst    | serve._rank | serve.start_year | serve.end_year |
      | hash('Tony Parker') | hash('Spurs') | 0           | 1999             | 2018           |
    # delete one vertex
    When executing query:
      """
      DELETE VERTEX hash("Tony Parker");
      """
    Then the execution should be successful
    # after delete to check value by fetch
    When executing query:
      """
      FETCH PROP ON player hash("Tony Parker") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID | player.name | player.age |
    # check value by fetch
    When executing query:
      """
      FETCH PROP ON serve hash("Tony Parker")->hash("Spurs") YIELD serve.start_year, serve.end_year
      """
    Then the result should be, in any order:
      | serve._src | serve._dst | serve._rank | serve.start_year | serve.end_year |
    # after delete to check value by go
    When executing query:
      """
      GO FROM hash("Boris Diaw") OVER like
      """
    Then the result should be, in any order:
      | like._dst          |
      | hash("Tim Duncan") |
    # after delete to check value by go
    When executing query:
      """
      GO FROM hash("Tony Parker") OVER like REVERSELY
      """
    Then the result should be, in any order:
      | like._dst |
    # before delete multi vertexes to check value by go
    When executing query:
      """
      GO FROM hash("Chris Paul") OVER like
      """
    Then the result should be, in any order:
      | like._dst               |
      | hash("LeBron James")    |
      | hash("Dwyane Wade")     |
      | hash("Carmelo Anthony") |
    # delete multi vertexes
    When executing query:
      """
      DELETE VERTEX hash("LeBron James"), hash("Dwyane Wade"), hash("Carmelo Anthony");
      """
    Then the execution should be successful
    # after delete multi vertexes to check value by go
    When executing query:
      """
      FETCH PROP ON player hash("Tony Parker") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID | player.name | player.age |
    # before delete hash id vertex to check value by go
    When executing query:
      """
      GO FROM hash("Tracy McGrady") OVER like
      """
    Then the result should be, in any order:
      | like._dst            |
      | 6293765385213992205  |
      | -2308681984240312228 |
      | -3212290852619976819 |
    # before delete hash id vertex to check value by go
    When executing query:
      """
      GO FROM hash("Grant Hill") OVER like REVERSELY
      """
    Then the result should be, in any order:
      | like._dst           |
      | 4823234394086728974 |
    # before delete hash id vertex to check value by fetch
    When executing query:
      """
      FETCH PROP ON player hash("Grant Hill") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID            | player.name  | player.age |
      | 6293765385213992205 | "Grant Hill" | 46         |
    # before delete hash id vertex to check value by fetch
    When executing query:
      """
      FETCH PROP ON serve hash("Grant Hill")->hash("Pistons") YIELD serve.start_year, serve.end_year
      """
    Then the result should be, in any order:
      | serve._src          | serve._dst           | serve._rank | serve.start_year | serve.end_year |
      | 6293765385213992205 | -2742277443392542725 | 0           | 1994             | 2000           |
    # delete hash id vertex
    When executing query:
      """
      DELETE VERTEX hash("Grant Hill")
      """
    Then the execution should be successful
    # after delete hash id vertex to check value by go
    When executing query:
      """
      GO FROM hash("Tracy McGrady") OVER like
      """
    Then the result should be, in any order:
      | like._dst           |
      | hash("Kobe Bryant") |
      | hash("Rudy Gay")    |
    # after delete hash id vertex to check value by go
    When executing query:
      """
      GO FROM hash("Grant Hill") OVER like REVERSELY
      """
    Then the result should be, in any order:
      | like._dst |
    # after delete hash id vertex to check value by fetch
    When executing query:
      """
      FETCH PROP ON player hash("Grant Hill") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID | player.name | player.age |
    # delete not existed vertex
    When executing query:
      """
      DELETE VERTEX hash("Non-existing Vertex")
      """
    Then the execution should be successful
    # delete a vertex without edges
    When executing query:
      """
      INSERT VERTEX player(name, age) VALUES hash("A Loner"): ("A Loner", 0);
      DELETE VERTEX hash("A Loner");
      """
    Then the execution should be successful
    # check delete a vertex without edges
    When executing query:
      """
      FETCH PROP ON player hash("A Loner") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID | player.name | player.age |
    # delete with no edge
    When executing query:
      """
      DELETE VERTEX hash("Nobody")
      """
    Then the execution should be successful
    # check delete with no edge
    When executing query:
      """
      FETCH PROP ON player hash("Nobody") YIELD player.name, player.age
      """
    Then the result should be, in any order:
      | VertexID | player.name | player.age |
    Then drop the used space
