#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams, games;")"


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
    if [[ $YEAR != year ]]
      #Check if the Winning team is already on the table
      then
        WINNING_TEAM=$($PSQL "SELECT name FROM teams WHERE name ='$WINNER';")
          if [[ -z $WINNING_TEAM ]]
            then
              INSERT_WINNING_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
                if [[ $INSERT_WINNING_TEAM == "INSERT 0 1" ]]
                  then
                  echo "Inserted into teams table, $WINNER"
                fi
          fi

        OPPOSING_TEAM=$($PSQL "SELECT name FROM teams WHERE name ='$OPPONENT';")
        if [[ -z $OPPOSING_TEAM ]]
          then
            INSERT_OPPOSING_TEAM="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
              if [[ $INSERT_OPPOSING_TEAM == "INSERT 0 1" ]]
                then
                echo "Inserted into teams table, $OPPONENT"
              fi
        fi

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
          if [[ $INSERT_NEW_ROW == "INSERT 0 1" ]]
                  then
                  echo "Inserted into games table, $WINNER_ID versus $OPPONENT_ID"
          fi
    fi
done    