sub proccesschanflags
{
 $chan = $_[0];
 $channels{$chan} = "";
 $bitchmode{$chan} = 'false';
 $opprot{$chan} = 'false';
 $modelock{$chan} = 'false';
 $topiclock{$chan} = 'false';
 $logging{$chan} = 'false';
 $needinvite{$chan} = "";
 $public_fm{$chan} = 'true';
 $public_sd{$chan} = 'true';                          
 @keys = split(' ',$_[1]);
 for ($i=0; $i<=$#keys; $i++)
  {
  $key = $keys[$i];
  $key =~ /([\+\-]?)(.*)/;
  $flag = $1;
  $key = $2;
  if ($flag eq '+')
   {
   if    ($key =~ /bitch(?:mode)?/i)    { $bitchmode{$chan} = true; }
   elsif ($key =~ /opprot/i)            { $opprot{$chan} = true; }
   elsif ($key =~ /modelock/i)          { $modelock{$chan} = true; }
   elsif ($key =~ /topiclock/i)         { $topiclock{$chan} = true; }
   elsif ($key =~ /log/i)               { $logging{$chan} = true; }
   elsif ($key =~ /key/i)
    {
    $i++;                                              $channels{$chan} =~
/([^,]*)[,]?(.*)/;
    $channels{$chan} = $1.','.$keys[$i];
    }
   elsif ($key =~ /modes/i)
    {
    $i++;
    $channels{$chan} =~ /([^,]*)[,]?(.*)/;
    $modes = $keys[$i];
    $data = $2;
    if ($modes =~ /k/)
     {
     $i++;
     $modes .= ' '.$keys[$i];
     }
    if ($modes =~ /l/)
     {
     $i++;        
     $modes .= ' '.$keys[$i];
     }
    $channels{$chan} = $modes.','.$data;
    }
   elsif ($key =~ /needinvite/i)
    {
    $data = '';
    $i++;
    while ($keys[$i] !~ /^[\+\-]{1,1}/ && $i <= $#keys)
     {
     $data .= $keys[$i].' ';
     $i++;
     }
    $i--;
    chop($data);
    $needinvite{$chan} = $data;
    }                   
   }
  else # if flag == '-'
   {
   if    ($key =~ /freshmeat/i)         { $public_fm{$chan} = 'false'; }
   elsif ($key =~ /slashdot/i)          { $public_sd{$chan} = 'false'; }
   }
  }
 if ($logging{$chan} eq true)
  {
  $logfiles{$chan} = openlogfile($chan);
  }
 elsif (defined($logfiles{$chan}))
  {
  close($logfiles{$chan});
  delete($logfiles{$chan});
  }
}           
