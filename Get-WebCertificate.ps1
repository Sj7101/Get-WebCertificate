# Define the website URL
$websiteUrl = "https://www.example.com"

# Create an HttpWebRequest object
$request = [Net.HttpWebRequest]::Create($websiteUrl)
$request.AllowAutoRedirect = $false  # Avoid redirection which may hide the certificate
$request.Timeout = 10000  # Timeout in milliseconds (10 seconds)

try {
    # Send the request and get the response
    $response = $request.GetResponse()

    # Get the SSL certificate
    $certificate = $request.ServicePoint.Certificate

    if ($certificate) {
        # Get the certificate details
        $certDetails = New-Object PSCustomObject -Property @{
            Subject         = $certificate.Subject
            Issuer          = $certificate.Issuer
            EffectiveDate   = $certificate.GetEffectiveDateString()
            ExpirationDate  = $certificate.GetExpirationDateString()
            Thumbprint      = $certificate.GetCertHashString()
            SerialNumber    = $certificate.GetSerialNumberString()
        }

        # Display the certificate details
        $certDetails | Format-List
    } else {
        Write-Host "No SSL certificate found."
    }

    # Close the response
    $response.Close()
} catch {
    Write-Host "Error: $_"
}
