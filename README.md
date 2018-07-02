# Farfetch
Test application for Farfetch evaluation

#### Networking
In this app, for networking, I wrapped a URLSession in a dispatcher for background fetching.  
The URLSession also makes it simpler to get running tasks and cancel them when not needed anymore, like when scrolling a table view with dinamyically loaded images.

#### Data Modeling
For representing data from the Marvel API, I leveraged the power of the `Codable` protocol.  
I also set up the structure in a way that is easily built upon.  

#### Abstraction
To make things easier both for reading and to use in the future, I abstracted the API calls in a few generic layers, hiding behind it the complexities of creating a request, dispatching it and decoding data.  
That way, one can make an API query in a single line of code.

#### Persistence
At first I thought about using `Core Data` for persistence because that is usually what code reviewers want to see, but in the end it turned out to be overkill.  
Since this app doesn't make extensive use of relationships between data models and the data load to be persisted is minimal, I went for practical and readable.  
I'm using a single file for a list of favorite characters, with a custom `Favorite` object which I encode to and decode from that file with the `NSCoding` protocol.

#### Testing
Coverage is a bit low, as the time frame for this exercise wasn't that permissive, but I managed to implement a simple stub and mocking engine and cover the most critical parts of the code.

#### Afterword
I hope you have as much fun reading my code as I had writing it, and that we can talk again soon.  
  
Best regards,  
Allan
