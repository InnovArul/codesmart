import smtplib
from Crypto.Cipher import AES;
import base64;
import os;
from email.mime.text import MIMEText

def encryption(privateInformation):
    BLOCK_SIZE = 16; #16 bytes = 128 bits
    PADDING = '{';
    
    pad = lambda s : s + (((BLOCK_SIZE - len(s)) % BLOCK_SIZE) * PADDING)
    EncodeAES = lambda c, s: base64.b64encode(c.encrypt(pad(s))) 
    secret = os.urandom(BLOCK_SIZE)
    print 'encryption key = ', secret
    
    cipher = AES.new(secret)
    encryptedString = EncodeAES(cipher, privateInformation)
    print 'encrypted string = ', encryptedString
    return secret, encryptedString

def decryption(encryptedString, key):
    BLOCK_SIZE = 16; #16 bytes = 128 bits
    PADDING = '{';
    
    DecodeAES = lambda c, e: c.decrypt(base64.b64decode(e)).rstrip(PADDING)
    
    cipher = AES.new(key)
    decryptedString = DecodeAES(cipher, encryptedString)
    print 'decrypted string = ', decryptedString
    return decryptedString   
    
secret, encryptedString = encryption('sensitive information')
decryption(encryptedString, secret)

msg = MIMEText('Testing some Mailgun awesomness')
msg['Subject'] = "Hello"
msg['From']    = "someother@mailgun.org"
msg['To']      = "innovwelt@gmail.com"

# connect to mailgun's SMTP server
s = smtplib.SMTP('smtp.mailgun.org', 587)
# login with sandbox domain
s.login('innovwelt@sandboxb8c5f91e0aee47d3bd52a3d9352737d4.mailgun.org', 'sathyam')
#send the mail
s.sendmail(msg['From'], msg['To'], msg.as_string())
# close the connection
s.quit()

#===============================================================================
# Helpful : https://www.youtube.com/watch?v=8PzDfykGg_g
#
# curl -s --user 'api:key-c1fbbd35865e6853223ae6b8357e866f' \
#     https://api.mailgun.net/v3/sandboxb8c5f91e0aee47d3bd52a3d9352737d4.mailgun.org/messages \
#     -F from='Informer <mailgun@sandboxb8c5f91e0aee47d3bd52a3d9352737d4.mailgun.org>' \
#     -F to=innovwelt@gmail.com \
#     -F subject='Mailgun email informer' \
#     -F text='sample test email message from mailgun account'
#===============================================================================