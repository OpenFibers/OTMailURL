A mailto scheme URL parser in objective-c.  

###Usage

Init a OTMailURL object with mailto link, then read the values from it.  

```objective-c
OTMailURL *mailURL = [[OTMailURL alloc] initWithString:
                      @"mailto:\
                      alice@example.com,bob@example.com%2ceve%40example.com?\
                      to=bob1@example.com,bob2@example.com&\
                      to=bob2%40example.com%2cbob3%40example.com&\
                      cc=bob@example.com&\
                      bcc=eve@example.com&\
                      body=bodytext&\
                      subject=hello"];
NSLog(@"to: %@\ncc: %@\nbcc: %@\nsubject: %@\nbody %@\n",
      mailURL.toMailAddresses,
      mailURL.ccMailAddresses,
      mailURL.bccMailAddresses,
      mailURL.subject,
      mailURL.body);
```

Result is:  

```
to: (
    "alice@example.com",
    "bob@example.com",
    "eve@example.com",
    "bob1@example.com",
    "bob2@example.com",
    "bob3@example.com"
)
cc: (
    "bob@example.com"
)
bcc: (
    "eve@example.com"
)
subject: hello
body bodytext
```

Under MIT Lisense