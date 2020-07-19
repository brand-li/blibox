.. include:: /_includes/snippets/__ANNOUNCEMENTS__.rst

.. _checkout-different-blibox-release:

***********************************
Checkout different Blibox release
***********************************

You now have the blibox downloaded at the latest version (``git master branch``). This is also recommended as it receives
bugfixes frequently. If you however want to stay on a stable release, you need to check out a
specific ``git tag``.

Lets say you want your blibox setup to be at release ``v1.0.1``, all you have to do is to check out
this specific git tag.

.. code-block:: bash

   host> cd path/to/blibox
   # Ensure you have latest from remote
   host> git fetch
   # Switch to this release
   host> git checkout v1.0.1


.. warning::
   Whenever you check out a different version, make sure that your ``.env`` file is up-to-date
   with the bundled ``env-example`` file. Different Blibox releases might require different
   settings to be available inside the ``.env`` file. Refer to the next section for how to
   create the ``.env`` file.


