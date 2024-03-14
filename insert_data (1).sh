#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# reset database tables
echo "$($PSQL "TRUNCATE teams, games;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != "year" ]]
      then
        # Add teams
          # winner team 
            # check if team is in table - get team id
            WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
            echo $WINNER_ID
            # if not found - insert into teams
            if [[ -z $WINNER_ID ]]
              then
                WINNER_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');")
                if [[ $WINNER_ID="INSERT 0 1" ]]
                  then
                    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
                    echo "inserted winner id is: $WINNER_ID"

                fi
            fi
          # opponent team
            # check if team is in table - get team id
            OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
            echo $OPPONENT_ID
            # if not found - insert into teams
            if [[ -z $OPPONENT_ID ]]
              then
                OPPONENT_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');")
                if [[ $OPPONENT_ID="INSERT 0 1" ]]
                  then
                    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
                    echo "inserted OPPONENT id is: $OPPONENT_ID"

                fi
            fi
        #
      # add game to games table
      INSERT_GAME_STATUS=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
      echo $INSERT_GAME_STATUS
    fi
  done