use strict;
use warnings;
use 5.010;
 
sub Exec {
    my @cells = @_;
    my $ip = 0;
    while ($cells[$ip] != 99) {
        my $op = $cells[$ip];
        my $s1 = $cells[$ip+1];
        my $s2 = $cells[$ip+2];
        my $d = $cells[$ip+3];
        if ($op == 1) {
            $cells[$d] = $cells[$s1] + $cells[$s2];
        } elsif($op == 2) {
            $cells[$d] = $cells[$s1] * $cells[$s2];
        }
        $ip += 4;
    }
    return $cells[0];
}

sub Part1 {
    my @cells = @_;
    @cells[1] = 12;
    @cells[2] = 2;
    return Exec(@cells);
}

sub Part2 {
    for(my $a=0; $a <= 99; $a++) {
        for(my $b=0; $b <= 99; $b++) {
            my @cells = @_;
            @cells[1] = $a;
            @cells[2] = $b;
            my $res = Exec(@cells);
            if ($res == 19690720) {
                return 100*$a+$b;
            }
        }
    }
    return -1;
}

my @cells = map { int $_ } split ",", <>;
my $res1 = Part1(@cells);
my $res2 = Part2(@cells);

print "part 1: $res1\n";
print "part 2: $res2\n";