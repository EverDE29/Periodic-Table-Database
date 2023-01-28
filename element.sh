#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
else
  ELEMENT_IDENTIFIER=$1

  # find element's atomic number
  if [[ $ELEMENT_IDENTIFIER =~ ^[0-9]+$ ]]
    then
      ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_IDENTIFIER")
  else
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_IDENTIFIER' OR name='$ELEMENT_IDENTIFIER'")
    fi

  # if element doesn't exist
  if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
    then 
      echo "I could not find that element in the database."
  else
    # joining element, properties, and types tables to find element's information
    ELEMENT_PROPERTIES=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_ATOMIC_NUMBER")

    echo $ELEMENT_PROPERTIES | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi
