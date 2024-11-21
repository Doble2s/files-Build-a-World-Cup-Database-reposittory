#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
#TRUNCATE TABLE games, teams;
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
  WINNER_NAME=$($PSQL "SELECT * FROM teams WHERE name='$WINNER';")
  if [[ -z $WINNER_NAME ]]
  then
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
  echo -e "\n insert $WINNER"
  fi
  OPPONENT_NAME=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT';")
  if [[ -z $OPPONENT_NAME ]]
  then
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
  echo -e "\n insert $OPPONENT"
  fi
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
  fi
done
