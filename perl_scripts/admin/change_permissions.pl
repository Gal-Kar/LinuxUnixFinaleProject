use User::pwent;

my $username = "exampleusername";
my $groupname = "examplegroup";

my $user = getpwnam($username);

# Extract the existing group IDs for the user
my @group_ids = split(',', $user->groups);

# Check if the user is already a member of the group
my $already_member = grep { $_ eq $groupname } @group_ids;

# If the user is not already a member of the group, add the group ID to the list
if (!$already_member) {
    push(@group_ids, $groupname);
    my $new_groups = join(',', @group_ids);
    $user->groups($new_groups);
    $user->passwd;  # required to save the changes
}
