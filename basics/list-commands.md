| Goal                               | Command                                                      |
| ---------------------------------- | -------------------------------------------------------------|
| List all files/folders recursively | `ls -R`                                                      |
| List with full paths               | `find .`                                                     |
| Only files                         | `find . -type f`                                             |
| Only directories                   | `find . -type d`                                             |
| Show details                       | `ls -lR`                                                     |
| Filter by name/pattern             | `find . -name "*.tf"`                                        |
| List all files sorted by size	     | `find . -type f -exec du -h {} +`                            |
| Show top 20	                     | `find . -type f -exec du -h {} + \| sort -rh \| head -n 20`  |