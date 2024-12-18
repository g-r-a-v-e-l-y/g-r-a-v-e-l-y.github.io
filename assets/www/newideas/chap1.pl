# Pass the names into the subroutine.

# Store the results in an associative array called "keyedNames".

%keyedNames = &GetInitials("Jane Austen", "Emily Bronte", "Mary Shelley" );



# Print out the initials, sorted:

print "Initials are ", join(', ', sort keys %keyedNames), ".\n";



# The GetInitials subroutine.

sub GetInitials  {



   # Let's store the arguments in a "names" array for clarity.

   @names = @_;



   # Process each name in turn:

   foreach $name ( @names )  {



      # The "split" function is explained in Chapter 15, "Function List".

      # In this statement, we're getting split to look for the ' ' in the name;

      # It returns an array of chunks of the original string (i.e. $name) which were

      # separated by spaces, i.e. the forename and surname respectively in our case.

      # The variables "$forename" and "$surname" are then assigned to this array

      # using parentheses to force an array assignment.

      ( $forename, $surname ) = split( ' ', $name );



      # OK, now we have the forename and surname. We use the "substr" function,

      # also explained in chapter 15, to extract the first character from each 

of these.

      # The "." operator concatenates two strings (for example, "aa"."bb" is "aabb")

      # so the variable "$inits" takes on the value of the initials of the name:

      $inits = substr( $forename, 0, 1 ) . substr( $surname, 0, 1 );



      # Now we store the name in an associative array using the initials as the key:

      $NamesByInitials{$inits} = $name;

      }



   # Having built the associative array, we simply refer to it at the end of the

   # subroutine so that it's value is the last thing evaluated here. It will then 

   # be passed back to the calling function.

   %NamesByInitials;

   }
