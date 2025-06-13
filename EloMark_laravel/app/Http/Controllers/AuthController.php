<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // Register
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:6'
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password)
        ]);

        return response([
            'user' => $user,
            'token' => $user-> createToken('secret') ->plainTextToken
        ]);
    }

    // Login
    public function login(Request $request)
    {
        //Validate Fields
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string'
        ]);

        $user = User::where('email', $request->email)->first();
        
        //Attempt Login
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        $token = $user->createToken('flutter-token')->plainTextToken;

        //Return user and token in reponse
        return response()->json([
            'token' => $token,
            'user' => $user
        ]);
    }

    // Logout
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out'],200);
    }

    //Get user details
public function user(Request $request)
{
    return response()->json($request->user());
}

}

