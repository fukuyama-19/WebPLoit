use HTTP::Request;
use LWP::UserAgent;
use Socket;
use Getopt::Long;

Getopt::Long::Configure(qw/no_getopt_compat/);
GetOptions(\%opts,
      'sock',       # socket checking
      'pt',       # port filtering
      'req',        # get request
      'sh',     # shell injected 
      'help',     # show this message
) || usage();


if ( $opts{'sock'} ) {
    print "WebPloit>";
    my $servip = <STDIN>;
    chop $servip;

    $host = gethostbyname($servip);
    $proto = "tcp";
    $port = "80";
    $sock = socket($host, PF_INET, $proto, $port);
    $ip6 = $sock->{PF_INET6};
    $ip4 = $sock->{PF_INET};

    $get = HTTP::Request->new(GET=>$ip4, $ip6);
    $ua = LWP::UserAgent->new();
    $req = $ua->request($get);
    
    @array = ('ipv6', 'ipv4');

    if ($req->is_success) {
       print "[+] Checking ... \n";
       sleep (3);
       print "[+] Checking All ip type : @array is checked \n";
       print "[+] Socket : $sock \n";
    } 
    if ($req->content =~ /Access Dinied/) {
       print "[+] Checking ... \n";
       sleep (3);
       print "[+] Failed \n";
    } else {
        print "[+] Checking ... \n";
       sleep (3);
       print "[+] Failed \n";
    }

    
} elsif ($opts{'pt'}) {
    print "WebPloit-host>";
    my $servip = <STDIN>;
    chop $servip;

    print "WebPloit-port>";
    my $port = <STDIN>;
    chop $port;


    $host = gethostbyname($servip);
    $port = getprotobynumber("$port");
    $protocol = "tcp";
    $sock = socket(PF_INET, $host, $port, $protocol);
    
    $porto = $sock->{PORT};
    
    $request = HTTP::Request->new(GET=>$sock);
    $ua = LWP::UserAgent->new();
    $req = $ua->request($request);

    if ($req->is_success($porto)) {
        print "[+] connecting ... \n";
        sleep(10);
        print "[+] Connected to $porto as sock->{PORT} \n";
        print "[+] attacking break \n";
    }

    if ($req->content =~ /Access Dinied/) {
        print "[+] connecting ... \n";
        sleep(3);
        print "[+] Not connect to port $porto as sock->{PORT} \n";
        print "[+] attacking break \n";
    }
} elsif ($opts{'req'}) {
    print "WebPLoit-UrlRequest>";
    my $servip = <STDIN>;
    chop $servip;
    
    if ( $url !~ /http\// ) { $url = "http://$servip"; }

    print "WebPloit-Request>";
    my $requ = <STDIN>;
    chop $requ ;

    $target = $servip;

    @array = ($requ);

    for $user(@array) {
        $get = $url.$user;
        $request = HTTP::Request->new(GET=>$get);
        $ua = LWP::UserAgent->new();
        $req = $ua->request($request);

        if ($req->is_success) {
            print "[+] Checking request ... \n";
            sleep (2);
            print "[+] Request found : $user => $target/$user \n";
        }

        if ($req->content =~ /Access Dinied/) {
            print "[+] Checking request ... \n";
            sleep (2);
            print "[+] Request not found \n";
        } else {
            print "[+] Checking request ... \n";
            sleep (2);
            print "[+] Request not found \n";
        }
    }
} elsif ($opts{'sh'}) {
    print "WebPloit-WebUrl>";
    my $web = <STDIN>;
    chop $web;

    if ( $url !~ /http/ ) { $url = "http://$web"; }

    sub shell {
        print <<OU;
        Shell script has been created
        Shell target request : $url 
        Shell host request : $web
        
        print "Shell>";
        my $shell = <STDIN>;
        chop $shell;

        print "Username>";
        my $username = <STDIN>;
        chop $username;

        print "Password>";
        my $password = <STDIN>;
        chop $password;
        
        use WWW:Mechanize;
        use LWP::UserAgent;
        use HTTP::Request;
        
        $mech = WWW::Mechanize->new();
        $mech->get($shell);
        $mech->follow_link( n => 3 );
        $mech->follow_link( text_regex => qr/download this/i );
        $link = $mech->follow_link(url => "$url");
        $user = $mech->submit_form(
            form_number => 3,
            fields => {
                username => "$username",
                password => "$password",
            },
        );

        $request = HTTP::Request->new(GET=>$user);
        $ua = LWP::UserAgent->new();
        $req = $ua->request($request);

        if ($req->is_success) {
            print "[+] Scanning the target shell \n";
            sleep (3);
            print "[+] Scanning succesed \n";
            print "[+] Username : $username \n";
            print "[+] Password : $password \n";
        } 

        if ($req->content =~ /Access Dinied/) {
            print "[+] Scanning the target shell \n";
            sleep (3);
            print "[+] Failed scanning \n";
        } else {
            print "[+] Scanning the target shell \n";
            sleep (3);
            print "[+] Failed scanning \n";
        }

        
OU
    }

    print shell();
    print "[+] Shell script will be starting ... \n";
    sleep (5);
    
    # shell script starting in this code 

    print "Shell>";
    my $shell = <STDIN>;
    chop $shell;

    print "Username>";
    my $username = <STDIN>;
    chop $username;

    print "Password>";
    my $password = <STDIN>;
    chop $password;
        
    use WWW::Mechanize;
    use LWP::UserAgent;
    use HTTP::Request;
        
    $mech = WWW::Mechanize->new();
    $mech->get($shell);
    $mech->follow_link( n => 3 );
    $mech->follow_link( text_regex => qr/download this/i );
    $mech->follow_link(url => $shell);
    $user = $mech->submit_form(
        form_number => 3,
        fields => {
            username => "$username",
            password => "$password",
        }
    );

    $request = HTTP::Request->new(GET=>$user);
    $ua = LWP::UserAgent->new();
    $req = $ua->request($request);

    if ($req->is_success) {
        print "[+] Scanning the target shell \n";
        sleep (3);
        print "[+] Scanning succesed \n";
        print "[+] Username : $username \n";
        print "[+] Password : $password \n";
    } 

    if ($req->content =~ /Access Dinied/) {
        print "[+] Scanning the target shell \n";
        sleep (3);
        print "[+] Failed scanning \n";
    } else {
        print "[+] Scanning the target shell \n";
        sleep (3);
        print "[+] Failed scanning \n";
    }
    

} elsif ($opts{'help'}) {
    usage();
} else {
    usage();
}

sub usage {
    die <<EO;

    (0)-----------(0)
        WEBPLOIT 
    (0)-----------(0)
    
    WEB EXPLOIT AND ATTACKING
    - port filtering connection
    - Getting request from the target
    - create shell script

    To use this tools, see this message text in this bellow 
    Usage help  

       --sock                      check the socket from the host name 
       --pt                        set port filtering
       --req                       get request from another target
       --sh                        shell script to getuser in system
       --help                      show this message help
EO
}