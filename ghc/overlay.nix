self: super: with super; {
	ghc = let inherit(ghc) name version; in runCommandLocal name {
		disallowedReferences = [ghc.out ghc.doc];
	} ''
		set -e
		mkdir -p $out
		cp -r ${ghc.out}/* $out

		PKG_DIR=$out/lib/ghc-${version}/lib/package.conf.d
		chmod -R +w $PKG_DIR/
		find $PKG_DIR/ -type f -exec sed -i '/^haddock-/d' {} \;
		$out/bin/ghc-pkg recache --package-db=$PKG_DIR

		chmod -R +w $out/bin/
		find $out/bin/ -type f -exec sed -i '/^docdir="/d' {} \;
		find $out/bin/ -type f -exec sed -i "s|${ghc.out}|$out|g" {} \;
	'';
}
