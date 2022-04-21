initSidebarItems({"constant":[["DEFAULT_COMMENT_CHAR","The default comment character for `message_prettify` (‘#’)"]],"enum":[["ApplyLocation","Possible application locations for git_apply see https://libgit2.org/libgit2/#HEAD/type/git_apply_options"],["AttrValue","All possible states of an attribute."],["AutotagOption","Automatic tag following options."],["BranchType","An enumeration for the possible types of branches"],["ConfigLevel","An enumeration of the possible priority levels of a config file."],["Delta","What type of change is described by a `DiffDelta`?"],["DiffBinaryKind","When producing a binary diff, the binary data returned will be either the deflated full (“literal”) contents of the file, or the deflated binary delta between the two sides (whichever is smaller)."],["DiffFormat","Possible output formats for diff data"],["DiffLineType","Line origin constants."],["Direction","An enumeration of the possible directions for a remote."],["ErrorClass","An enumeration of possible categories of things that can have errors when working with a git repository."],["ErrorCode","An enumeration of possible errors that can happen when working with a git repository."],["FetchPrune","Configuration for how pruning is done on a fetch"],["FileFavor","Merge file favor options for `MergeOptions` instruct the file-level merging functionality how to deal with conflicting regions of the files."],["FileMode","Valid modes for index and tree entries."],["ObjectType","An enumeration all possible kinds objects may have."],["PackBuilderStage","Stages that are reported by the `PackBuilder` progress callback."],["RebaseOperationType","A rebase operation"],["ReferenceType","An enumeration of all possile kinds of references."],["RepositoryState","A listing of the possible states that a repository can be in."],["ResetType","An enumeration of the operations that can be performed for the `reset` method on a `Repository`."],["StashApplyProgress",""],["StatusShow","Enumeration of possible methods of what can be shown through a status operation."],["SubmoduleIgnore","Submodule ignore values"],["SubmoduleUpdate","Submodule update values"],["TreeWalkMode","A binary indicator of whether a tree walk should be performed in pre-order or post-order."],["TreeWalkResult","Possible return codes for tree walking callback functions."],["WorktreeLockStatus","Lock Status of a worktree"]],"fn":[["message_prettify","Clean up a message, removing extraneous whitespace, and ensure that the message ends with a newline. If `comment_char` is `Some`, also remove comment lines starting with that character."]],"mod":[["build","Builder-pattern objects for configuration various git operations."],["cert","Certificate types which are passed to `CertificateCheck` in `RemoteCallbacks`."],["oid_array","Bindings to libgit2’s raw `git_oidarray` type"],["opts","Bindings to libgit2’s git_libgit2_opts function."],["string_array","Bindings to libgit2’s raw `git_strarray` type"],["transport","Interfaces for adding custom transports to libgit2"]],"struct":[["AnnotatedCommit","A structure to represent an annotated commit, the input to merge and rebase."],["ApplyOptions","Options to specify when applying a diff"],["AttrCheckFlags",""],["Blame","Opaque structure to hold blame results."],["BlameHunk","Structure that represents a blame hunk."],["BlameIter","An iterator over the hunks in a blame."],["BlameOptions","Blame options"],["Blob","A structure to represent a git blob"],["BlobWriter","A structure to represent a git writestream for blobs"],["Branch","A structure to represent a git branch"],["Branches","An iterator over the branches inside of a repository."],["Buf","A structure to wrap an intermediate buffer used by libgit2."],["CheckoutNotificationType","Types of notifications emitted from checkouts."],["CherrypickOptions","Options to specify when cherry picking"],["Commit","A structure to represent a git commit"],["Config","A structure representing a git configuration key/value store"],["ConfigEntries","An iterator over the `ConfigEntry` values of a `Config` structure."],["ConfigEntry","A struct representing a certain entry owned by a `Config` instance."],["Cred","A structure to represent git credentials in libgit2."],["CredentialHelper","Management of the gitcredentials(7) interface."],["CredentialType","Types of credentials that can be requested by a credential callback."],["Deltas","An iterator over the diffs in a delta"],["Describe","The result of a `describe` operation on either an `Describe` or a `Repository`."],["DescribeFormatOptions","Options which can be used to customize how a description is formatted."],["DescribeOptions","Options which indicate how a `Describe` is created."],["Diff","The diff object that contains all individual file deltas."],["DiffBinary","Structure describing the binary contents of a diff."],["DiffBinaryFile","The contents of one of the files in a binary diff."],["DiffDelta","Description of changes to one entry."],["DiffFile","Description of one side of a delta."],["DiffFindOptions","Control behavior of rename and copy detection"],["DiffFlags",""],["DiffHunk","Structure describing a hunk of a diff."],["DiffLine","Structure describing a line (or data span) of a diff."],["DiffOptions","Structure describing options about how the diff should be executed."],["DiffStats","Structure describing a hunk of a diff."],["DiffStatsFormat","Formatting options for diff stats"],["Error","A structure to represent errors coming out of libgit2."],["FetchOptions","Options which can be specified to various fetch operations."],["Index","A structure to represent a git index"],["IndexAddOption","Flags for APIs that add files matching pathspec"],["IndexConflict","A structure to represent the information returned when a conflict is detected in an index entry"],["IndexConflicts","An iterator over the conflicting entries in an index"],["IndexEntries","An iterator over the entries in an index"],["IndexEntry","A structure to represent an entry or a file inside of an index."],["IndexEntryExtendedFlag","Flags for the `extended_flags` field of an IndexEntry."],["IndexEntryFlag","Flags for the `flags` field of an IndexEntry."],["IndexTime","Time structure used in a git index entry."],["Mailmap","A structure to represent a repository’s .mailmap file."],["Mempack","A structure to represent a mempack backend for the object database. The Mempack is bound to the Odb that it was created from, and cannot outlive that Odb."],["MergeAnalysis","The results of `merge_analysis` indicating the merge opportunities."],["MergeOptions","Options to specify when merging."],["MergePreference","The user’s stated preference for merges."],["Note","A structure representing a note in git."],["Notes","An iterator over all of the notes within a repository."],["Object","A structure to represent a git object"],["Odb","A structure to represent a git object database"],["OdbObject","An object from the Object Database."],["OdbPackwriter","A stream to write a packfile to the ODB"],["OdbReader","A structure to represent a git ODB rstream"],["OdbWriter","A structure to represent a git ODB wstream"],["Oid","Unique identity of any object (commit, tree, blob, tag)."],["PackBuilder","A builder for creating a packfile"],["Parents","An iterator over the parent commits of a commit."],["Patch","A structure representing the text changes in a single diff delta."],["Pathspec","Structure representing a compiled pathspec used for matching against various structures."],["PathspecDiffEntries","Iterator over the matching diff deltas."],["PathspecEntries","Iterator over the matched paths in a pathspec."],["PathspecFailedEntries","Iterator over the failed list of pathspec items that did not match."],["PathspecFlags","…"],["PathspecMatchList","List of filenames matching a pathspec."],["Progress","Struct representing the progress by an in-flight transfer."],["ProxyOptions","Options which can be specified to various fetch operations."],["PushOptions","Options to control the behavior of a git push."],["Rebase","Representation of a rebase"],["RebaseOperation","A rebase operation"],["RebaseOptions","Rebase options"],["Reference","A structure to represent a git reference."],["ReferenceFormat","Options for [`Reference::normalize_name`]."],["ReferenceNames","An iterator over the names of references in a repository."],["References","An iterator over the references in a repository."],["Reflog","A reference log of a git repository."],["ReflogEntry","An entry inside the reflog of a repository"],["ReflogIter","An iterator over the entries inside of a reflog."],["Refspec","A structure to represent a git refspec."],["Refspecs","An iterator over the refspecs that a remote contains."],["Remote","A structure representing a remote of a git repository."],["RemoteCallbacks","A structure to contain the callbacks which are invoked when a repository is being updated or downloaded."],["RemoteConnection","Holds callbacks for a connection to a `Remote`. Disconnects when dropped"],["RemoteHead","Description of a reference advertised by a remote server, given out on calls to `list`."],["Repository","An owned git repository, representing all state associated with the underlying filesystem."],["RepositoryInitMode","Mode options for RepositoryInitOptions"],["RepositoryInitOptions","Options which can be used to configure how a repository is initialized"],["RepositoryOpenFlags","Flags for `Repository::open_ext`"],["RevertOptions","Options to specify when reverting"],["RevparseMode","Flags for the return value of `Repository::revparse`"],["Revspec","A revspec represents a range of revisions within a repository."],["Revwalk","A revwalk allows traversal of the commit graph defined by including one or more leaves and excluding one or more roots."],["Signature","A Signature is used to indicate authorship of various actions throughout the library."],["Sort","Orderings that may be specified for Revwalk iteration."],["StashApplyFlags",""],["StashApplyOptions","Stash application options structure"],["StashFlags",""],["Status","Status flags for a single file"],["StatusEntry","A structure representing an entry in the `Statuses` structure."],["StatusIter","An iterator over the statuses in a `Statuses` instance."],["StatusOptions","Options that can be provided to `repo.statuses()` to control how the status information is gathered."],["Statuses","A container for a list of status information about a repository."],["Submodule","A structure to represent a git submodule"],["SubmoduleStatus","Return codes for submodule status."],["SubmoduleUpdateOptions","Options to update a submodule."],["Tag","A structure to represent a git tag"],["Time","Time in a signature"],["Transaction","A structure representing a transactional update of a repository’s references."],["Tree","A structure to represent a git tree"],["TreeBuilder","Constructor for in-memory trees"],["TreeEntry","A structure representing an entry inside of a tree. An entry is borrowed from a tree."],["TreeIter","An iterator over the entries in a tree."],["Worktree","An owned git worktree"],["WorktreeAddOptions","Options which can be used to configure how a worktree is initialized"],["WorktreePruneOptions","Options to configure how worktree pruning is performed"]],"trait":[["IntoCString","A class of types that can be converted to C strings."]],"type":[["Credentials","Callback used to acquire credentials for when a remote is fetched."],["IndexMatchedPath","A callback function to filter index matches."],["IndexerProgress","Callback to be invoked while indexing is in progress."],["StashApplyProgressCb","Stash application progress notification function."],["StashCb","This is a callback function you can provide to iterate over all the stashed states that will be invoked per entry."],["TransportMessage","Callback for receiving messages delivered by the transport."],["UpdateTips","Callback for whenever a reference is updated locally."]]});